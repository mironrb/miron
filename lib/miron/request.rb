require 'digest/sha1'
require 'base64'
require 'socket'
require 'active_support/core_ext/hash/keys'

module Miron
  # Miron::Request converts an env hash of HTTP variables to a proper {Miron::Request} object.
  #
  class Request
    attr_reader :protocol, :request_hash
    attr_accessor :hash

    # @param  [Hash] request_hash
    #         Request information
    #
    # @param  [String] protocol
    #         HTTP protocol (either HTTP-1-1 or HTTP-2-0)
    #
    def initialize(request_hash, protocol)
      @hash = request_hash
      @protocol = protocol
      fix_hash_keys
    end

    def fetch_multipart_data
      return nil unless multipart?

      tempfile = @hash['miron.input'].read

      ## HEADER MANAGEMENT
      file_headers = tempfile.split("\r\n\r\n")[0]
      file_info = file_headers.split('; ')[2].split("\r\n")
      file_name = file_info[0].delete!('""').split('=')[1]
      file_type = file_info[1].split(' ')[1]

      ## CONTENT MANAGEMENT
      file_contents = tempfile.split("\r\n\r\n")[1].split("\r\n")[0]

      {
        file_contents: file_contents,
        file_name: file_name,
        file_type: file_type
      }
    end

    def method
      @hash['HTTP_METHOD']
    end

    def multipart?
      @hash['CONTENT_TYPE'].include?('multipart/form-data')
    end

    def ssl?
      @hash['HTTPS']
    end

    # Websockets
    #-----------------------------------------------------------------------------#

    WS_MAGIC_STRING = '258EAFA5-E914-47DA-95CA-C5AB0DC85B11'

    def setup_websocket
      if @hash['SERVER_SOFTWARE'].include?('WEBrick')
        fail NotImplementedError, 'WEBrick does not support websockets.'
      end

      # socket-ify
      socket = @hash['miron.socket'].call
      websocket_handshake(socket)
      @websocket_connection = Miron::WebsocketConnection.new(socket)
    rescue Errno::EPIPE => e
      @websocket_connection.dispatch_event("\x88", '')
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

    def fix_hash_keys
      if @protocol == 'HTTP-1-1'
        fix_hash_keys_rack
      elsif @protocol == 'HTTP-2-0'
        fix_hash_keys_http2
      end
    end

    COLON = ':'.freeze

    def fix_hash_keys_http2
      # Convert path to PATH
      if @hash[':path']
        @hash['PATH'] = @hash[':path']
        @hash.delete(':path')
      end

      # Convert method to HTTP_METHOD
      if @hash[':method']
        @hash['HTTP_METHOD'] = @hash[':method']
        @hash.delete(':method')
      end

      # Set HTTPS hash key
      if @hash[':scheme'] == 'https'
        @hash.delete(':scheme')
        @hash['HTTPS'] = true
      else
        @hash['HTTPS'] = false
      end
    end

    # Make request hash keys easier to understand.
    # This should be here until all in tree handlers convert to Miron.
    # #rackhacks
    def fix_hash_keys_rack
      # Convert PATH_INFO to PATH
      if @hash['PATH_INFO']
        @hash['PATH'] = @hash['PATH_INFO']
        @hash.delete('PATH_INFO')
      end

      # Convert REQUEST_METHOD to HTTP_METHOD
      if @hash['REQUEST_METHOD']
        @hash['HTTP_METHOD'] = @hash['REQUEST_METHOD']
        @hash.delete('REQUEST_METHOD')
      end

      # Set HTTPS hash key
      return unless @hash['HTTPS'] && @hash['HTTPS'].is_a?(String)
      if @hash['HTTPS'] == 'on'
        @hash.delete('HTTPS')
        @hash['HTTPS'] = true
      else
        @hash['HTTPS'] = false
      end
    end
  end
end
