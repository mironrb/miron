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
    # @param  [] app
    #         App to perform a `.call` on
    #
    def initialize(miron_request, miron_response, app)
      @miron_request = miron_request
      @miron_response = miron_response
      @app = app
    end

    # @return [Response] returns the newly created {Miron::Response}
    #
    def fetch_response
      @app.new.call(@miron_request)
    end
  end
end
