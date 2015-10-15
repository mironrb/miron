require 'spec_helper'

describe Miron::Request do
  describe 'In general' do
    it 'can be initialized' do
      request_hash = { 'PATH_INFO' => '/', 'REQUEST_METHOD' => 'GET' }
      request = Miron::Request.new(request_hash)

      expect(request.class).to eq(Miron::Request)
      expect(request).to be_an_instance_of(Miron::Request)
    end

    it 'modifies hash correctly' do
      request_hash = { 'PATH_INFO' => '/', 'REQUEST_METHOD' => 'GET' }
      request = Miron::Request.new(request_hash)

      expect(request.hash).to eq({ 'PATH' => '/', 'HTTP_METHOD' => 'GET' })
      expect(request.hash).to_not eq({ 'PATH_INFO' => '/', 'REQUEST_METHOD' => 'GET' })
    end
  end

  describe '#websocket?' do
    it 'returns true correctly' do
      request_hash = { 'HTTP_SEC_WEBSOCKET_KEY' => 'LALALA' }
      request = Miron::Request.new(request_hash)
      expect(request.websocket?).to eq(true)
    end

    it 'returns false correctly' do
      request_hash = { 'LALALA' => 'LALALA' }
      request = Miron::Request.new(request_hash)
      expect(request.websocket?).to eq(false)
    end
  end
end
