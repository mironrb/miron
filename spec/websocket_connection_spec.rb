require 'spec_helper'
require 'socket'

describe Miron::WebsocketConnection do
  describe 'In general' do
    after do
      @server.close
      @socket.close
    end

    before do
      @server = TCPServer.new('0.0.0.0', 6000)
      @socket = TCPSocket.new('0.0.0.0', 6000)
    end

    it 'can be initialized' do
      websocket_connection = Miron::WebsocketConnection.new(@socket)

      expect(websocket_connection.class).to eq(Miron::WebsocketConnection)
      expect(websocket_connection).to be_an_instance_of(Miron::WebsocketConnection)
      expect(websocket_connection.socket.class).to eq(TCPSocket)
    end
  end
end
