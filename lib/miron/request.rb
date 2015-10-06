module Miron
  # Miron::Request allows HTTP responses to be sent.
  #
  class Request
    attr_reader :request, :miron_response, :app

    # @param  [Hash] request
    #         Request information
    #
    # @param  [Mironfile] mironfile
    #         Mironfile that has the app and middleware to perform a `.call` on
    #
    def initialize(request, mironfile)
      @request = request
      @mironfile = mironfile
      fix_hash_keys
    end

    # @return [Response] returns the newly created {Miron::Response}
    #
    def fetch_response
      miron_response = nil
      @mironfile.middleware.each do |middleware|
        middleware_response = middleware.call(@request)
        miron_response = middleware_response if middleware_response.is_a?(Miron::Response)
      end

      return miron_response unless miron_response.nil?

      app_response = @mironfile.app.call(@request)
      miron_response = app_response if app_response.is_a?(Miron::Response)
      miron_response
    end

    private

    # Make request hash keys easier to understand.
    def fix_hash_keys
      # Convert PATH_INFO to PATH
      return unless @request['PATH_INFO']
      @request['PATH'] = @request['PATH_INFO']
      @request.delete('PATH_INFO')

      # Convert REQUEST_METHOD to HTTP_METHOD
      return unless @request['REQUEST_METHOD']
      @request['HTTP_METHOD'] = @request['REQUEST_METHOD']
      @request.delete('REQUEST_METHOD')
    end
  end
end
