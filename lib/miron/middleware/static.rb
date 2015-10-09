require 'mimemagic'

module Miron
  module Middleware
    class Static
      attr_reader :filesystem_root, :url_path
      attr_reader :request, :response

      ALLOWED_VERBS = ['GET' 'HEAD' 'OPTIONS']
      ALLOW_HEADER = ALLOWED_VERBS.join(', ')

      def initialize(args)
        @filesystem_root = args[0] || Dir.pwd
        @url_path = args[1] if args[1]
      end

      def call(request, response)
        @request = request
        @response = response

        # Check to make sure it's a valid HTTP method
        check_request

        path = @filesystem_root + request['PATH']

        # Make sure file is available
        check_for_file

        # Calculate important things about the file
        file = File.read(path)
        file_size = file.size.to_s
        file_type = MimeMagic.by_extension(::File.extname(path)) || 'text/plain'

        # Return a response!
        @response.http_status = 200
        @response.headers = { 'Content-Length' => file_size, 'Content-Type' => file_type, 'Last-Modfied' => ::File.mtime(path).httpdate }
        @response.body = file
        @response
      end

      def check_for_file
        ::File.file?(path) && ::File.readable?(path)
      rescue SystemCallError
        @response.http_status = 404
        @response.headers = {}
        @response.body = 'Not found'
        @response
      end

      def check_request
        return unless ALLOWED_VERBS.include?(@request['HTTP_METHOD'])
        @response.http_status = 405
        @response.headers = { 'Allow' => ALLOW_HEADER }
        @response.body = 'Method Not Allowed'
        @response
      end
    end
  end
end
