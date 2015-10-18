require 'spec_helper'
require 'socket'

describe Miron::WebsocketConnection do
  after do
    @server.close
    @socket.close
  end

  before do
    @server = TCPServer.new('0.0.0.0', 6000)
    @socket = TCPSocket.new('0.0.0.0', 6000)
  end

  describe 'In general' do
    it 'can be initialized' do
      websocket_connection = Miron::WebsocketConnection.new(@socket)

      expect(websocket_connection.class).to eq(Miron::WebsocketConnection)
      expect(websocket_connection).to be_an_instance_of(Miron::WebsocketConnection)
      expect(websocket_connection.socket.class).to eq(TCPSocket)
    end
  end

  describe '#on' do
    it 'close --> is added to hash' do
      websocket_connection = Miron::WebsocketConnection.new(@socket)
      websocket_connection.on :close do
      end

      expect(websocket_connection.conn_close_handlers.size).to eq(1)
    end

    it 'message --> is added to hash' do
      websocket_connection = Miron::WebsocketConnection.new(@socket)
      websocket_connection.on :message do
      end

      expect(websocket_connection.conn_message_handlers.size).to eq(1)
    end

    it 'open --> is added to hash' do
      websocket_connection = Miron::WebsocketConnection.new(@socket)
      websocket_connection.on :open do
      end

      expect(websocket_connection.conn_open_handlers.size).to eq(1)
    end

    it 'ping --> is added to hash' do
      websocket_connection = Miron::WebsocketConnection.new(@socket)
      websocket_connection.on :ping do
      end

      expect(websocket_connection.conn_ping_handlers.size).to eq(1)
    end
  end
end
