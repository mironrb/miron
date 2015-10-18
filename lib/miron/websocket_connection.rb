require 'socket'

module Miron
  class WebsocketConnection
    PONG_OPCODE = 0x10
    TEXT_OPCODE = 0x01

    attr_reader :socket

    def initialize(socket)
      @conn_close_handlers = []
      @conn_message_handlers = []
      @conn_open_handlers = []
      @conn_ping_handlers = []
      @socket = socket
    end

    # Use `dispatch_event_` to call event handlers.
    def dispatch_event(fin_and_opcode, message)
      # See https://tools.ietf.org/html/rfc6455#section-11.8 for a list of opcodes
      # Unpack the fin_and_opcode from bytes to a string
      string_opcode = fin_and_opcode.pack('c*')
      # Text Frame
      if string_opcode == "\x81"
        @conn_message_handlers.each { |handler| handler.call(message) }
      # Connection Close Frame
      elsif string_opcode == "\x88"
        @conn_close_handlers.each { |handler| handler.call(message) }
      # Ping Frame
      elsif string_opcode == "\x89"
        @conn_ping_handlers.each { |handler| handler.call(message) }
      end
    end

    # Set websocket event handlers.
    # Pass in a block, such as:
    # connection.on :close {|message| puts message}
    def on(event, &block)
      case event
      when :close
        @conn_close_handlers << block
      when :message
        @conn_message_handlers << block
      when :open
        @conn_open_handlers << block
      when :ping
        @conn_ping_handlers << block
      end
    end

    # Coming soon.
    def pong
    end

    # Send data to the client.
    def send(message)
      bytes = [0x80 | TEXT_OPCODE]
      size = message.bytesize

      bytes += if size <= 125
                 [size] # i.e. `size | 0x00`; if masked, would be `size | 0x80`, or size + 128
               elsif size < 2**16
                 [126] + [size].pack('n').bytes
               else
                 [127] + [size].pack('Q>').bytes
               end

      bytes += message.bytes
      data = bytes.pack('C*')
      socket << data
    end

    # Start listening for data, parse, and dispatch it.
    def start
      fin_and_opcode = socket.read(1).bytes
      mask_and_length_indicator = socket.read(1).bytes[0]
      length_indicator = mask_and_length_indicator - 128

      length =  if length_indicator <= 125
                  length_indicator
                elsif length_indicator == 126
                  socket.read(2).unpack('n')[0]
                else
                  socket.read(8).unpack('Q>')[0]
                end

      keys = socket.read(4).bytes
      encoded = socket.read(length).bytes

      decoded = encoded.each_with_index.map do |byte, index|
        byte ^ keys[index % 4]
      end

      message = decoded.pack('c*')
      dispatch_event(fin_and_opcode, message)
    end
  end
end
