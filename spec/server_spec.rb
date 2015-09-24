require 'spec_helper'

describe Miron::Server do
  describe 'In general' do
    it 'can be initialized' do
      server = Miron::Server.new('hello', { 'port' => 9290, 'server' => 'webrick' })
      expect(server.mironfile).to eq('hello')
      expect(server.options).to eq('port' => 9290, 'server' => 'webrick')
    end
  end

  describe '#start' do
    context 'handler exists' do
      it 'returns defined Handler' do
        server = Miron::Server.new('hello', { 'port' => 9290, 'server' => 'webrick' })
        expect(server.handler).to eq(Miron::Handler::WEBrick)
      end
    end

    context 'handler does not exist' do
      it 'returns Miron::Handler::WEBrick' do
        server = Miron::Server.new('hello', { 'port' => 9290, 'server' => 'hello' })
        expect(server.handler).to eq(Miron::Handler::WEBrick)
      end
    end
  end
end
