require 'puma'

module Miron
  class Handler
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
        miron_response = Miron::Request.new(miron_request, @mironfile).fetch_response
        # Process response
        response_http_status = miron_response.http_status
        response_hash_values = miron_response.cookies.merge(miron_response.headers)
        response_body = [miron_response.body]
        [response_http_status, response_hash_values, response_body]
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
          puts "Miron backed Puma server has started on http://#{@options['host']}:#{@options['port']}"
          sleep
        end
      end
    end
  end
end
