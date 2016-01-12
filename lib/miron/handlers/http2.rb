require 'http/2'
require 'socket'
require 'openssl'
require 'webrick'
require 'webrick/https'

module Miron
  module Handler
    class Http2
      def self.run(mironfile, options = {})
        Http2Server.new(mironfile, options)
      end

      class Http2Server
        DRAFT = 'h2'

        class Logger
          def initialize(id)
            @id = id
          end

          def info(msg)
            puts "[Stream #{@id}]: #{msg}"
          end
        end

        def initialize(mironfile, options)
          @mironfile = mironfile
          @options = options

          server = setup_server
          puts 'Starting Http2 server...'

          loop do
            sock = server.accept
            puts 'New TCP connection!'

            conn = HTTP2::Server.new
            conn.on(:frame) do |bytes|
              sock.write bytes
            end
            conn.on(:frame_sent) do |frame|
              puts "Sent frame: #{frame.inspect}"
            end
            conn.on(:frame_received) do |frame|
              puts "Received frame: #{frame.inspect}"
            end

            conn.on(:stream) do |stream|
              log = Logger.new(stream.id)
              req = {}
              buffer = ''

              stream.on(:active) { log.info 'cliend opened new stream' }
              stream.on(:close)  { log.info 'stream closed' }

              stream.on(:headers) do |h|
                req = Hash[*h.flatten]
                log.info "request headers: #{h}"
              end

              stream.on(:data) do |d|
                log.info "payload chunk: <<#{d}>>"
                buffer << d
              end

              stream.on(:half_close) do
                fetch_response
              end
            end

            while !sock.closed? && !(sock.eof? rescue true) # rubocop:disable Style/RescueModifier
              data = sock.readpartial(1024)

              begin
                conn << data
              rescue => e
                puts "Exception: #{e}, #{e.message} - closing socket."
                sock.close
              end
            end
          end
        end

        private

        def fetch_response
          miron_request = req
          miron_response = Miron::RequestFetcher.new(miron_request, 'HTTP-2-0', @mironfile).fetch_response

          default_headers = {
            ':status' => miron_response.http_status.to_s,
            'content-length' => miron_response.body.bytesize.to_s,
            'content-type' => 'text/plain'
          }

          response_headers = default_headers.merge!(miron_response.headers)
          stream.headers(response_headers, end_stream: false)

          require 'pry'; binding.pry
          # split response into multiple DATA frames
          stream.data(miron_response.body.slice!(0, 5), end_stream: false)
          stream.data(miron_response.body)
        end

        def setup_server
          server = TCPServer.new(@options['port'])

          ctx = OpenSSL::SSL::SSLContext.new

          ssl_cert = @options['ssl-cert'] || 'keys/mycert.pem'
          ctx.cert = OpenSSL::X509::Certificate.new(File.open(ssl_cert))

          ssl_key = @options['ssl-key'] || 'keys/mykey.pem'
          ctx.key = OpenSSL::PKey::RSA.new(File.open(ssl_key))
          ctx.npn_protocols = [DRAFT]

          OpenSSL::SSL::SSLServer.new(server, ctx)
        end
      end
    end
  end
end
