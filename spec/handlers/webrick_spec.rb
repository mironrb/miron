require 'spec_helper'

describe Miron::Handler::WEBrick do
  describe 'In general' do
    it 'inherits from Miron::Handler::Base' do
      expect(Miron::Handler::WEBrick.superclass).to eq(Miron::Handler::Base)
    end

    it 'responds to self.run' do
      expect(Miron::Handler::WEBrick).to respond_to(:run)
    end
  end
end
