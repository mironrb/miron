require File.expand_path('../spec_helper', __FILE__)

describe Miron::Server do
  describe 'In general' do
    it 'can be initialized' do
      server = Miron::Server.new('hello', { 'port' => 9290 })
      expect(server.mironfile).to eq('hello')
      expect(server.options).to eq('port' => 9290)
    end
  end
end
