module Miron
  module Middleware
    class SSL
      def self.call(request, response)
        if check_ssl(request)
          # All good!
          true
        else
          # Redirect to HTTPS
          redirect_to_https(request, response)
        end
      end

      def self.check_ssl(request)
        if request.hash['HTTPS']
          true
        elsif request.hash['HTTP_X_FORWARDED_PROTO']
          return true if request.hash['HTTP_X_FORWARDED_PROTO'].split(',')[0]
        else
          false
        end
      end

      def self.redirect_to_https(request, response)
        host = request.hash['HTTP_HOST']
        path = request.hash['PATH']
        location = "https://#{host}#{path}"

        response.http_status = %w(GET HEAD).include?(request.hash['HTTP_METHOD']) ? 301 : 307
        response.headers = { 'Content-Type' => 'text/html', 'Location' => location }
        response.body = ''
        response
      end
    end
  end
end
