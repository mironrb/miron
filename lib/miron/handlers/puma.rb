require 'puma'

module Miron
  module Handler
    class Puma
      def self.run(mironfile, options = {})
        Puma::Proxy.new(mironfile, options)
      end

      def initialize(mironfile)
        @mironfile = mironfile
      end

      def call(env)
        # Get response
        miron_request = env
        miron_request['miron.socket'] = miron_request['rack.hijack']
        miron_response = Miron::RequestFetcher.new(miron_request, HTTP_1_1, @mironfile).fetch_response
        # Process response
        response_http_status = miron_response.http_status
        # Add cookies to headers
        miron_response.cookies.each do |k, v|
          miron_response.headers['Set-Cookie'] = "#{k}=#{v}"
        end
        response_body = [miron_response.body]
        [response_http_status, miron_response.headers, response_body]
      end

      class Proxy
        def initialize(mironfile, options)
          @mironfile = mironfile
          @options = options
          @serv = ::Puma::Server.new(Puma.new(@mironfile))
          listen(@options['host'], @options['port'].to_i)
        end

        def stop
          @serv.stop
        end

        def listen(address, port)
          @serv.add_tcp_listener(address, port)
          @serv.run
          puts "Puma #{::Puma::Const::PUMA_VERSION} starting..."
          puts "* Environment: #{@options['environment']}"
          puts "* Listening on #{@options['host']}:#{@options['port']}"
          begin
            sleep
          rescue Interrupt
            puts '* Shutting down...'
          end
        end
      end
    end
  end
end
