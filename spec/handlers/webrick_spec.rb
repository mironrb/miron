require 'spec_helper'
require 'webrick'
require 'net/http'

describe Miron::Handler::WEBrick do
  describe 'In general' do
    it 'inherits from Miron::Handler::Base' do
      expect(Miron::Handler::WEBrick.superclass).to eq(WEBrick::HTTPServlet::AbstractServlet)
    end

    it 'responds to self.run' do
      expect(Miron::Handler::WEBrick).to respond_to(:run)
    end
  end

  describe 'Handler' do
    sample_app

    it 'returns the correct HTTP status' do
      response = get
      expect(response.code.to_i).to eq(200)
    end

    it 'returns the correct HTTP body' do
      response = get
      expect(response.body).to eq('hi')
    end
  end
end
