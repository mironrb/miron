module Miron
  # Miron::Reponse allows HTTP responses to be sent.
  #
  class Response
    attr_accessor :http_status, :headers, :body, :cookies

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
    def initialize
      @http_status = 200
      @headers = {}
      @body = ''
      @cookies = {}
    end
  end
end
