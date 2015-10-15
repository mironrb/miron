module Miron
  # Miron::Request converts an env hash of HTTP variables to a proper {Miron::Request} object.
  #
  class Request
    attr_reader :request_hash
    attr_accessor :hash

    # @param  [Hash] request_hash
    #         Request information
    #
    def initialize(request_hash)
      @hash = request_hash
      fix_hash_keys
    end

    def websocket?
      @hash.key?('HTTP_SEC_WEBSOCKET_KEY')
      # Also known as "Sec-WebSocket-Key"
    end

    private

    # Make request hash keys easier to understand.
    def fix_hash_keys
      # Convert PATH_INFO to PATH
      return unless @hash['PATH_INFO']
      @hash['PATH'] = @hash['PATH_INFO']
      @hash.delete('PATH_INFO')

      # Convert REQUEST_METHOD to HTTP_METHOD
      return unless @hash['REQUEST_METHOD']
      @hash['HTTP_METHOD'] = @hash['REQUEST_METHOD']
      @hash.delete('REQUEST_METHOD')
    end
  end
end
