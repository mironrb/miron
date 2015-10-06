require 'spec_helper'

describe Miron::Response do
  describe 'In general' do
    it 'can be initialized' do
      response = Miron::Response.new
      response.http_status = 200
      response.headers = { 'Content-Type' => 'text/plain' }
      response.body = 'hello'
      response.cookies = { 'HELLO456' => 'HELLO456' }

      expect(response.http_status).to eq(200)
      expect(response.headers).to eq('Content-Type' => 'text/plain')
      expect(response.body).to eq('hello')
      expect(response.cookies).to eq('HELLO456' => 'HELLO456')
    end
  end
end
