module Miron
  module Auth
    class Basic
      attr_reader :request

      def self.call(request)
        @request = request
        return unauthorized if authorization_key.nil?
        check_auth
      end

      def self.auth_cleared
        true
      end

      def self.authorization_key
        authorization_keys = ['HTTP_AUTHORIZATION', 'HTTP_X-HTTP_AUTHORIZATION', 'HTTP_X_HTTP_AUTHORIZATION']
        @authorization_key ||= authorization_keys.detect { |key| @request.key?(key) } || nil
      end

      def self.bad_request
        Miron::Response.new(400, { 'Content-Type' => 'text/plain', 'Content-Length' => '0' }, '')
      end

      def self.check_auth
        # Get Auth Scheme and encoded username/password
        auth_key = @request[authorization_key].split(' ', 2)
        scheme = auth_key.first && auth_key.first.downcase
        return bad_request if scheme != 'basic'

        # Validate credentials
        decrypted_auth_key = auth_key.last.unpack('m*').first.split(/:/, 2)
        if [ENV['MIRON_BAUTH_USERNAME'], ENV['MIRON_BAUTH_PWD']] == decrypted_auth_key
          return auth_cleared
        else
          return unauthorized
        end
      end

      def self.unauthorized
        Miron::Response.new(401,
                            { 'Content-Type' => 'text/plain',
                              'Content-Length' => '0',
                              'WWW-Authenticate' => 'Basic realm="Login"'
                            },
                            '')
      end
    end
  end
end
