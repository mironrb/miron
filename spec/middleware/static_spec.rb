require 'spec_helper'

describe Miron::Middleware::Static do
  sample_static_app

  context 'invalid HTTP method' do
    it 'returns the correct HTTP body' do
      response = get_static('invalid-http')
      expect(response.body).to eq('Method Not Allowed')
    end

    it 'returns the correct HTTP headers' do
      response = get_static('invalid-http')
      expect(response.headers['Allow']).to eq('GETHEADOPTIONS')
      expect(response.headers['Content-Length']).to eq('18')
      expect(response.headers['Content-Type']).to eq(nil)
      expect(response.headers['Last-Modified']).to eq(nil)
    end

    it 'returns the correct HTTP status' do
      response = get_static('invalid-http')
      expect(response.code.to_i).to eq(405)
    end
  end

  context 'invalid file' do
    it 'returns the correct HTTP body' do
      response = get_static('invalid-file')
      expect(response.body).to eq('Not found')
    end

    it 'returns the correct HTTP headers' do
      response = get_static('invalid-file')
      expect(response.headers['Content-Length']).to eq('9')
      expect(response.headers['Content-Type']).to eq(nil)
      expect(response.headers['Last-Modified']).to eq(nil)
    end

    it 'returns the correct HTTP status' do
      response = get_static('invalid-file')
      expect(response.code.to_i).to eq(404)
    end
  end

  context 'valid file' do
    it 'returns the correct HTTP body' do
      response = get_static('valid-file')
      expect(response.body).to eq("hi\n")
    end

    it 'returns the correct HTTP headers' do
      response = get_static('valid-file')
      expect(response.headers['Content-Length']).to eq('3')
      expect(response.headers['Content-Type']).to eq('text/plain')
      expect(response.headers['Last-Modified']).to eq('Fri, 09 Oct 2015 22:15:20 GMT')
    end

    it 'returns the correct HTTP status' do
      response = get_static('valid-file')
      expect(response.code.to_i).to eq(200)
    end
  end
end
