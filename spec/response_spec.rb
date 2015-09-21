require 'spec_helper'

describe Miron::Response do
  describe 'In general' do
    it 'can be initialized' do
      response = Miron::Response.new(200, { 'Content-Type' => 'text/plain' }, 'hello', { 'HELLO456' => 'HELLO456' })
      expect(response.http_status).to eq(200)
      expect(response.headers).to eq('Content-Type' => 'text/plain')
      expect(response.body).to eq('hello')
      expect(response.cookies).to eq('HELLO456' => 'HELLO456')
    end
  end
end
