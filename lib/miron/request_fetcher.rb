module Miron
  class RequestFetcher
    def initialize(request, mironfile)
      @request = Miron::Request.new(request)
      @mironfile = mironfile
      @response = Miron::Response.new
    end

    # @return [Response] returns the newly created {Miron::Response}
    #
    def fetch_response
      miron_response = nil
      @mironfile.middleware.each do |middleware|
        middleware_response = middleware.call(@request, @response)
        miron_response = middleware_response if middleware_response.is_a?(Miron::Response)
      end

      return miron_response unless miron_response.nil?

      app_response = @mironfile.app.call(@request, @response)
      miron_response = app_response if app_response.is_a?(Miron::Response)
      miron_response
    end
  end
end
