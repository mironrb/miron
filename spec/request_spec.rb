require 'spec_helper'

describe Miron::Request do
  describe 'In general' do
    it 'can be initialized' do
      request_hash = { 'PATH_INFO' => '/', 'REQUEST_METHOD' => 'GET', 'HTTPS' => 'on' }
      request = Miron::Request.new(request_hash, HTTP_1_1)

      expect(request.class).to eq(Miron::Request)
      expect(request).to be_an_instance_of(Miron::Request)
    end

    it 'modifies hash correctly' do
      request_hash = { 'PATH_INFO' => '/', 'REQUEST_METHOD' => 'GET', 'HTTPS' => 'on' }
      request = Miron::Request.new(request_hash, HTTP_1_1)

      expect(request.hash).to eq({ 'PATH' => '/', 'HTTP_METHOD' => 'GET', 'HTTPS' => true })
      expect(request.hash).to_not eq({ 'PATH_INFO' => '/', 'REQUEST_METHOD' => 'GET', 'HTTPS' => 'on' })
    end
  end

  describe '#fetch_multipart_data' do
    it 'returns correct hash' do
      fixture_file = File.join(File.dirname(__FILE__), 'support/fixtures/testfile.txt')
      @data = RestClient::Payload.generate(name_of_file_param: File.new(fixture_file)).read

      request_hash = {
        'CONTENT_LENGTH' => @data.bytesize.to_s,
        'CONTENT_TYPE' => %(multipart/form-data; boundary=AaB03x),
        'miron.input' => StringIO.new(@data)
      }

      request = Miron::Request.new(request_hash, HTTP_1_1)
      result = request.fetch_multipart_data

      expect(result.class).to eq(Hash)
      expect(result.keys).to eq([:file_contents, :file_name, :file_type])
      expect(result[:file_contents]).to eq("testfile\n")
      expect(result[:file_name]).to eq('testfile.txt')
      expect(result[:file_type]).to eq('text/plain')
    end
  end

  describe '#method' do
    it 'returns the correct HTTP method' do
      request_hash = { 'REQUEST_METHOD' => 'GET' }
      request = Miron::Request.new(request_hash, HTTP_1_1)

      expect(request.method).to eq('GET')
    end
  end

  describe '#multipart?' do
    context 'hash key present' do
      it 'returns true' do
        request_hash = { 'CONTENT_TYPE' => 'multipart/form-data' }
        request = Miron::Request.new(request_hash, HTTP_1_1)

        expect(request.multipart?).to eq(true)
      end
    end

    context 'hash key not present' do
      it 'returns false' do
        request_hash = { 'CONTENT_TYPE' => 'not-multipart' }
        request = Miron::Request.new(request_hash, HTTP_1_1)

        expect(request.multipart?).to eq(false)
      end
    end
  end

  describe '#ssl?' do
    it 'returns the correct value' do
      request_hash_1 = { 'HTTPS' => 'on' }
      request_hash_2 = { 'HTTPS' => true }
      request_1 = Miron::Request.new(request_hash_1, HTTP_1_1)
      request_2 = Miron::Request.new(request_hash_2, HTTP_1_1)

      expect(request_1.ssl?).to eq(true)
      expect(request_2.ssl?).to eq(true)
    end

    it 'returns the correct value' do
      request_hash = { 'HTTPS' => false }
      request = Miron::Request.new(request_hash, HTTP_1_1)

      expect(request.ssl?).to eq(false)
    end
  end

  describe '#setup_websocket' do
    context 'incompatible server' do
      it 'fails with NotImplementedError' do
        request_hash = { 'SERVER_SOFTWARE' => 'WEBrick' }
        request = Miron::Request.new(request_hash, HTTP_1_1)

        expect do
          request.setup_websocket
        end.to raise_error(NotImplementedError, 'WEBrick does not support websockets.')
      end
    end

    context 'compatible server' do
      it 'does not fail with NotImplementedError' do
        request_hash = { 'SERVER_SOFTWARE' => 'Puma' }
        request = Miron::Request.new(request_hash, HTTP_1_1)

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
        request = Miron::Request.new(request_hash, HTTP_1_1)

        expect(request.setup_websocket).to be_an_instance_of(Miron::WebsocketConnection)
      end
    end
  end

  describe '#websocket?' do
    it 'returns true correctly' do
      request_hash = { 'HTTP_METHOD' => 'GET', 'HTTP_SEC_WEBSOCKET_KEY' => 'LALALA' }
      request = Miron::Request.new(request_hash, HTTP_1_1)

      expect(request.websocket?).to eq(true)
    end

    it 'returns false correctly' do
      request_hash = { 'HTTP_METHOD' => 'POST', 'LALALA' => 'LALALA' }
      request = Miron::Request.new(request_hash, HTTP_1_1)

      expect(request.websocket?).to eq(false)
    end
  end
end
