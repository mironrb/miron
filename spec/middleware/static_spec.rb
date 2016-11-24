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
      time = Time.parse(response.headers['Last-Modified'])

      # Get last modified information from file
      last_modified_date = File.mtime(ROOT + 'spec/support/hello/hi.txt')
      last_modified_month = last_modified_date.month
      last_modified_year = last_modified_date.year

      expect(time.month).to eq(last_modified_month)
      expect(time.year).to eq(last_modified_year)
    end

    it 'returns the correct HTTP status' do
      response = get_static('valid-file')
      expect(response.code.to_i).to eq(200)
    end
  end
end
