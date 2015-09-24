module Miron
  # Miron::Request allows HTTP responses to be sent.
  #
  class Request
    attr_reader :miron_request, :miron_response, :app

    # @param  [Class] miron_request
    #         Request object (can be an instance of `WEBrick::Request`)
    #
    # @param  [Class] miron_response
    #         Response object (can be an instance of `WEBrick::Response`)
    #
    # @param  [Mironfile] mironfile
    #         Mironfile that has the app and middleware to perform a `.call` on
    #
    def initialize(miron_request, miron_response, mironfile)
      @miron_request = miron_request
      @miron_response = miron_response
      @mironfile = mironfile
    end

    # @return [Response] returns the newly created {Miron::Response}
    #
    def fetch_response
      miron_response = nil
      @mironfile.middleware.each do |middleware|
        middleware_response = middleware.call(@miron_request)
        miron_response = middleware_response if middleware_response.is_a?(Miron::Response)
      end

      return miron_response unless miron_response.nil?

      app_response = @mironfile.app.call(@miron_request)
      miron_response = app_response if app_response.is_a?(Miron::Response)
      miron_response
    end
  end
end
