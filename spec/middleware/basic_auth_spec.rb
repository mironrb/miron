require 'spec_helper'

describe Miron::Middleware::BasicAuth do
  describe 'Middleware' do
    context 'correct authentication credentials' do
      sample_basic_auth_app(auth: true)
      response = get_basic_auth(auth: true)

      it 'returns the correct HTTP body' do
        expect(response.body).to eq('hi')
      end

      it 'returns the correct HTTP cookies' do
        expect(response.headers['set-cookie']).to eq('HELLO=HELLO')
      end

      it 'returns the correct HTTP headers' do
        expect(response.headers['hello']).to eq('HELLO')
      end

      it 'returns the correct HTTP status' do
        expect(response.code.to_i).to eq(200)
      end
    end

    context 'incorrect authentication credentials' do
      sample_basic_auth_app(auth: false)

      it 'returns the correct HTTP body' do
        response = get_basic_auth(auth: false)
        expect(response.body).to eq('')
      end

      it 'returns the correct HTTP headers' do
        response = get_basic_auth(auth: false)
        expect(response.headers['www-authenticate']).to eq("Basic realm=\"Login\"")
      end

      it 'returns the correct HTTP status' do
        response = get_basic_auth(auth: false)
        expect(response.code.to_i).to eq(401)
      end
    end
  end
end
