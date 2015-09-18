require File.expand_path('../spec_helper', __FILE__)

describe Miron::Response do
  describe 'In general' do
    it 'can be initialized' do
      response = Miron::Response.new(200, { 'Content-Type' => 'text/plain' }, 'hello')
      expect(response.http_status).to eq(200)
      expect(response.options).to eq('Content-Type' => 'text/plain')
      expect(response.body).to eq('hello')
    end
  end
end
