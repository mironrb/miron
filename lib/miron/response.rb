module Miron
  # Miron::Reponse allows HTTP responses to be sent.
  #
  class Response
    attr_reader :http_status, :options, :body

    # @param  [Integer] http_status
    #         the HTTP status code to return
    #
    # @param  [Hash] options
    #         the HTTP headers to return
    #
    # @param  [String] body
    #         the HTTP body to return
    #
    # @return [Response] returns the newly created {Miron::Response}
    #
    def initialize(http_status, options, body)
      @http_status = http_status
      @options = options
      @body = body
    end
  end
end
