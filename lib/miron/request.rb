require 'digest/sha1'
require 'base64'
require 'socket'

module Miron
  # Miron::Request converts an env hash of HTTP variables to a proper {Miron::Request} object.
  #
  class Request
    WS_MAGIC_STRING = '258EAFA5-E914-47DA-95CA-C5AB0DC85B11'

    attr_reader :request_hash
    attr_accessor :hash

    # @param  [Hash] request_hash
    #         Request information
    #
    def initialize(request_hash)
      @hash = request_hash
      fix_hash_keys
    end

    def setup_websocket
      if @hash['SERVER_SOFTWARE'].include?('WEBrick')
        fail NotImplementedError, 'WEBrick does not support websockets.'
      end

      # socket-ify
      socket = @hash['miron.socket'].call
      websocket_handshake(socket)
      Miron::WebsocketConnection.new(socket)
    end

    # Checks to see if 'Sec-Websocket-Key' HTTP header is in the request header hash.
    def websocket?
      @hash['HTTP_METHOD'] == 'GET' && @hash.key?('HTTP_SEC_WEBSOCKET_KEY')
    end

    def websocket_handshake(socket)
      digest = Digest::SHA1.digest(@hash['HTTP_SEC_WEBSOCKET_KEY'] + WS_MAGIC_STRING)
      accept_code = Base64.encode64(digest)
      socket.write("HTTP/1.1 101 Switching Protocols\r\n" +
                "Upgrade: websocket\r\n" +
                "Connection: Upgrade\r\n" +
                "Sec-WebSocket-Accept: #{accept_code}\r\n")
      socket.flush
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
