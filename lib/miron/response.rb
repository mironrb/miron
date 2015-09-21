module Miron
  # Miron::Reponse allows HTTP responses to be sent.
  #
  class Response
    attr_reader :http_status, :headers, :body, :cookies

    # @param  [Integer] http_status
    #         the HTTP status code to return
    #
    # @param  [Hash] headers
    #         the HTTP headers to return
    #
    # @param  [String] body
    #         the HTTP body to return
    #
    # @return [Response] returns the newly created {Miron::Response}
    #
    def initialize(http_status, headers, body, cookies = {})
      @http_status = http_status
      @headers = headers
      @body = body
      @cookies = cookies
    end
  end
end
