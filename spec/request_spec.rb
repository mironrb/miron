require 'spec_helper'

describe Miron::Request do
  describe 'In general' do
    it 'can be initialized' do
      request_hash = { 'PATH_INFO' => '/', 'REQUEST_METHOD' => 'GET', 'HTTPS' => 'on' }
      request = Miron::Request.new(request_hash)

      expect(request.class).to eq(Miron::Request)
      expect(request).to be_an_instance_of(Miron::Request)
    end

    it 'modifies hash correctly' do
      request_hash = { 'PATH_INFO' => '/', 'REQUEST_METHOD' => 'GET', 'HTTPS' => 'on' }
      request = Miron::Request.new(request_hash)

      expect(request.hash).to eq({ 'PATH' => '/', 'HTTP_METHOD' => 'GET', 'HTTPS' => true })
      expect(request.hash).to_not eq({ 'PATH_INFO' => '/', 'REQUEST_METHOD' => 'GET', 'HTTPS' => 'on' })
    end
  end

  describe '#setup_websocket' do
    context 'incompatible server' do
      it 'fails with NotImplementedError' do
        request_hash = { 'SERVER_SOFTWARE' => 'WEBrick' }
        request = Miron::Request.new(request_hash)

        expect do
          request.setup_websocket
        end.to raise_error(NotImplementedError, 'WEBrick does not support websockets.')
      end
    end

    context 'compatible server' do
      it 'does not fail with NotImplementedError' do
        request_hash = { 'SERVER_SOFTWARE' => 'Puma' }
        request = Miron::Request.new(request_hash)

        expect do
          request.setup_websocket
        end.to_not raise_error(NotImplementedError, 'Puma does not support websockets.')
      end

      it 'returns an instance of Miron::WebsocketConnection' do
        class Hi
          def call
            TCPServer.new('0.0.0.0', 7000)
            TCPSocket.new('0.0.0.0', 7000)
          end
        end

        @miron_socket = Hi.new
        request_hash = { 'HTTP_SEC_WEBSOCKET_KEY' => '123', 'SERVER_SOFTWARE' => 'Puma', 'miron.socket' => @miron_socket }
        request = Miron::Request.new(request_hash)

        expect(request.setup_websocket).to be_an_instance_of(Miron::WebsocketConnection)
      end
    end
  end

  describe '#websocket?' do
    it 'returns true correctly' do
      request_hash = { 'HTTP_METHOD' => 'GET', 'HTTP_SEC_WEBSOCKET_KEY' => 'LALALA' }
      request = Miron::Request.new(request_hash)

      expect(request.websocket?).to eq(true)
    end

    it 'returns false correctly' do
      request_hash = { 'HTTP_METHOD' => 'POST', 'LALALA' => 'LALALA' }
      request = Miron::Request.new(request_hash)

      expect(request.websocket?).to eq(false)
    end
  end
end
