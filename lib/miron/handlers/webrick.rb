require 'webrick'
require 'logger'

module Miron
  class Handler
    class WEBrick < ::WEBrick::HTTPServlet::AbstractServlet
      def self.run(mironfile, options = {})
        options[:BindAddress] = options['default_host']
        options[:Port] = options['port']
        @server = ::WEBrick::HTTPServer.new(options)
        @server.mount('/', Miron::Handler::WEBrick, mironfile)
        yield @server if block_given?
        @server.start
      end

      def initialize(server, mironfile)
        super server
        @mironfile = mironfile
      end

      def service(webrick_request, webrick_response)
        miron_request = webrick_request.meta_vars
        miron_response = Miron::Request.new(miron_request, webrick_response, @mironfile).fetch_response

        webrick_response.status = miron_response.http_status
        webrick_response.body << miron_response.body
        miron_response.headers.each { |k, v| webrick_response[k] = v }
        miron_response.cookies.each { |k, v| webrick_response.cookies << "#{k}=#{v}" }
        miron_response.body.close if miron_response.body.respond_to?(:close)
      end

      def shutdown
        @server.shutdown
      end
    end
  end
end
