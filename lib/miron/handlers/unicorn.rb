require 'unicorn'

module Miron
  class Handler
    class Unicorn < Unicorn::HttpServer
      def self.run(mironfile, options = {})
        Unicorn::Proxy.new(mironfile, options)
      end

      def initialize(mironfile, options)
        @mironfile = mironfile
        super
      end

      def process_client(socket)
        # Get response
        miron_request = @request.read(socket)
        miron_response = Miron::RequestFetcher.new(miron_request, @mironfile).fetch_response
        # Process response
        response_http_status = miron_response.http_status
        # Add cookies to headers
        miron_response.cookies.each do |k, v|
          miron_response.headers['Set-Cookie'] = "#{k}=#{v}"
        end
        response_body = [miron_response.body]
        # Write back to Unicorn
        http_response_write(socket, response_http_status, miron_response.headers, response_body)
        unless socket.closed?
          socket.shutdown
          socket.close
        end
      rescue => e
        handle_error(socket, e)
      end

      class Proxy
        def initialize(mironfile, options)
          @mironfile = mironfile
          @options = options
          listen(@options['host'], @options['port'].to_i)
        end

        def listen(address, port)
          puts 'Unicorn starting...'
          puts "* Environment: #{@options['environment']}"
          puts "* Listening on #{@options['host']}:#{@options['port']}"
          begin
            ::Miron::Handler::Unicorn.new(@mironfile, {
                                            listeners: ["#{address}:#{port}"],
                                            logger: Logger.new(nil)
                                          }).start.join
          rescue Interrupt
            puts '* Shutting down...'
          end
        end
      end
    end
  end
end
