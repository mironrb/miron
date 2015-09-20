require 'webrick'
require 'logger'

module Miron
  class Handler
    class WEBrick < ::WEBrick::HTTPServlet::AbstractServlet
      def self.run(app, options = {})
        environment  = ENV['MIRON_ENV'] || 'development'
        default_host = environment == 'development' ? 'localhost' : nil

        options[:BindAddress] = options.delete(:Host) || default_host
        options[:Port] = options['port']
        @server = ::WEBrick::HTTPServer.new(options)
        @server.mount('/', Miron::Handler::WEBrick, app)
        yield @server if block_given?
        @server.start
      end

      def initialize(server, app)
        super server
        @app = app
      end

      def service(webrick_request, webrick_response)
        miron_request = webrick_request.meta_vars
        miron_response = webrick_response
        Miron::Request.new(miron_request, miron_response)
      end

      def shutdown
        @server.shutdown
      end
    end
  end
end
