module Miron
  module Middleware
    class BasicAuth
      attr_reader :request, :response

      def initialize(args)
        @username = args[0]
        @password = args[1]
      end

      def call(request, response)
        @request = request
        @response = response
        return unauthorized if authorization_key.nil?
        check_auth
      end

      def auth_cleared
        true
      end

      def authorization_key
        authorization_keys = ['HTTP_AUTHORIZATION', 'HTTP_X-HTTP_AUTHORIZATION', 'HTTP_X_HTTP_AUTHORIZATION']
        @authorization_key ||= authorization_keys.detect { |key| @request.key?(key) } || nil
      end

      def bad_request
        @response.http_status = 400
        @response.headers = { 'Content-Type' => 'text/plain', 'Content-Length' => '0' }
        @response.body = ''
        @response
      end

      def check_auth
        # Get Auth Scheme and encoded username/password
        auth_key = @request[authorization_key].split(' ', 2)
        scheme = auth_key.first && auth_key.first.downcase
        return bad_request if scheme != 'basic'

        # Validate credentials
        decrypted_auth_key = auth_key.last.unpack('m*').first.split(/:/, 2)
        if [@username, @password] == decrypted_auth_key
          return auth_cleared
        else
          return unauthorized
        end
      end

      def unauthorized
        @response.http_status = 401
        @response.headers = { 'Content-Type' => 'text/plain',
                              'Content-Length' => '0',
                              'WWW-Authenticate' => 'Basic realm="Login"'
                            }
        @response.body = ''
        @response
      end
    end
  end
end
