require 'spec_helper'
require 'thin'

describe Miron::Handler::Thin do
  describe 'In general' do
    it 'inherits from Thin::Server' do
      expect(Miron::Handler::Thin.superclass).to eq(Thin::Server)
    end

    it 'responds to self.run' do
      expect(Miron::Handler::Thin).to respond_to(:run)
    end
  end

  describe 'Handler' do
    sample_thin_app

    it 'returns the correct HTTP body' do
      response = get
      expect(response.body).to eq('hi')
    end

    it 'returns the correct HTTP cookies' do
      response = get
      expect(response.headers['set-cookie']).to eq('HELLO=HELLO')
    end

    it 'returns the correct HTTP headers' do
      response = get
      expect(response.headers['hello']).to eq('HELLO')
    end

    it 'returns the correct HTTP status' do
      response = get
      expect(response.code.to_i).to eq(200)
    end
  end
end
