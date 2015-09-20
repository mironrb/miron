require 'spec_helper'

describe Miron::Handler do
  describe '#get' do
    context 'handler exists' do
      it 'returns defined Handler' do
        expect(Miron::Handler.get('webrick')).to eq(Miron::Handler::WEBrick)
      end
    end

    context 'handler does not exist' do
      it 'returns Miron::Handler::WEBrick' do
        expect(Miron::Handler.get('hello')).to eq(Miron::Handler::WEBrick)
      end
    end
  end
end
