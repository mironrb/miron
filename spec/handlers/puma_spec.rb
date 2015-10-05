require 'spec_helper'
require 'puma'

describe Miron::Handler::Puma do
  describe 'In general' do
    it 'responds to self.run' do
      expect(Miron::Handler::Puma).to respond_to(:run)
    end
  end

  describe 'Handler' do
    sample_puma_app

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
