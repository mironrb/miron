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
      @mironfile.middleware.each do |middleware|
        middleware.constantize.call(@miron_request)
      end

      @mironfile.app.constantize.call(@miron_request)
    end
  end
end
