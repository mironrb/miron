require 'thin'

module Miron
  module Handler
    class Thin < Thin::Server
      def self.run(mironfile, options = {})
        Thin::Proxy.new(mironfile, options)
      end

      def initialize(mironfile, *args)
        @mironfile = mironfile
        super
      end

      def call(env)
        # Get response
        miron_request = env
        miron_request['miron.socket'] = miron_request['rack.hijack']
        miron_response = Miron::RequestFetcher.new(miron_request, @mironfile).fetch_response
        # Process response
        response_http_status = miron_response.http_status
        # Add cookies to headers
        miron_response.cookies.each do |k, v|
          miron_response.headers['Set-Cookie'] = "#{k}=#{v}"
        end
        response_body = [miron_response.body]
        # Write back to Unicorn
        [response_http_status, miron_response.headers, response_body]
      end

      def start
        @app = self
        super
      end

      class Proxy
        def initialize(mironfile, options)
          @mironfile = mironfile
          @options = options
          listen(@options['host'], @options['port'].to_i)
        end

        def listen(address, port)
          args = [address, port, nil]
          # Thin versions below 0.8.0 do not support additional options
          args.pop if ::Thin::VERSION::MAJOR < 1 && ::Thin::VERSION::MINOR < 8
          server = ::Miron::Handler::Thin.new(@mironfile, *args)
          yield server if block_given?
          server.start
        end
      end
    end
  end
end
