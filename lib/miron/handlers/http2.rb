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
              req, buffer = {}, ''

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
                log.info 'client closed its end of the stream'

                response = nil
                if req[':method'] == 'POST'
                  log.info "Received POST request, payload: #{buffer}"
                  response = "Hello HTTP 2.0! POST payload: #{buffer}"
                else
                  log.info 'Received GET request'
                  response = 'Hello HTTP 2.0! GET request'
                end

                stream.headers({
                  ':status' => '200',
                  'content-length' => response.bytesize.to_s,
                  'content-type' => 'text/plain',
                }, end_stream: false)

                # split response into multiple DATA frames
                stream.data(response.slice!(0, 5), end_stream: false)
                stream.data(response)
              end
            end

            while !sock.closed? && !(sock.eof? rescue true) # rubocop:disable Style/RescueModifier
              data = sock.readpartial(1024)
              # puts "Received bytes: #{data.unpack("H*").first}"

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

        def setup_server
          server = TCPServer.new(@options['port'])

          ctx = OpenSSL::SSL::SSLContext.new
          ctx.cert = OpenSSL::X509::Certificate.new(File.open('keys/mycert.pem'))
          ctx.key = OpenSSL::PKey::RSA.new(File.open('keys/mykey.pem'))
          ctx.npn_protocols = [DRAFT]

          OpenSSL::SSL::SSLServer.new(server, ctx)
        end
      end
    end
  end
end
