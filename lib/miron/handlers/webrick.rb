require 'webrick'
require 'webrick/https'
require 'logger'
require 'stringio'

module Miron
  class Handler
    class WEBrick < ::WEBrick::HTTPServlet::AbstractServlet
      def self.run(mironfile, options = {})
        options[:BindAddress] = options['host']
        options[:Port] = options['port']
        @server = ::WEBrick::HTTPServer.new(options)
        @server.mount('/', Miron::Handler::WEBrick, mironfile)
        yield @server if block_given?

        begin
          @server.start
        rescue Interrupt
          puts '* Shutting down...'
        end
      end

      def initialize(server, mironfile)
        super server
        @mironfile = mironfile
      end

      def service(webrick_request, webrick_response)
        miron_request = webrick_request.meta_vars
        parse_input_body(webrick_request, miron_request)
        miron_response = Miron::RequestFetcher.new(miron_request, @mironfile).fetch_response

        webrick_response.status = miron_response.http_status
        webrick_response.body << miron_response.body
        miron_response.headers.each { |k, v| webrick_response[k] = v }
        miron_response.cookies.each { |k, v| webrick_response.cookies << "#{k}=#{v}" }
        miron_response.body.close if miron_response.body.respond_to?(:close)
      end

      def parse_input_body(webrick_request, miron_request)
        if webrick_request.body.to_s.nil? || webrick_request.body.to_s.empty?
          miron_request['HTTP_BODY'] = ''
        else
          miron_request['HTTP_BODY'] = ::MultiJson.load(webrick_request.body.to_s)
        end
      end

      def shutdown
        @server.shutdown
      end
    end
  end
end
