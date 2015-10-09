require 'mimemagic'
require 'pathname'

module Miron
  module Middleware
    class Static
      attr_reader :filesystem_root, :url_path
      attr_reader :request, :response

      ALLOWED_VERBS = ['GET' 'HEAD' 'OPTIONS']
      ALLOW_HEADER = ALLOWED_VERBS.join(', ')

      def initialize(args)
        @filesystem_root = (Pathname.pwd + args[0]).to_s || Dir.pwd.to_s
        @url_path = args[1] if args[1]
      end

      def call(request, response)
        @request = request
        @response = response

        # Check to make sure it's a valid HTTP method
        if check_request_method == true
          @request_file_path = Pathname.new(@filesystem_root + request['PATH'])
          # Make sure file is available
          if check_for_file == true
            # Calculate important things about the file
            file = File.read(@request_file_path)
            file_size = file.size.to_s
            file_type = MimeMagic.by_extension(File.extname(@request_file_path)) || 'text/plain'
            file_last_modified = File.mtime(@request_file_path.to_s).httpdate

            # Return a response!
            @response.http_status = 200
            @response.headers = { 'Content-Length' => file_size, 'Content-Type' => file_type, 'Last-Modified' => "#{file_last_modified}" }
            @response.body = file
            @response
          else
            return_404
          end
        else
          return_405
        end
      end

      def check_for_file
        File.exist?(@request_file_path)
      end

      def check_request_method
        ALLOWED_VERBS.first.include?(@request['HTTP_METHOD'])
      end

      def return_404
        @response.http_status = 404
        @response.headers = {}
        @response.body = 'Not found'
        @response
      end

      def return_405
        @response.http_status = 405
        @response.headers = { 'Allow' => ALLOW_HEADER }
        @response.body = 'Method Not Allowed'
        @response
      end
    end
  end
end
