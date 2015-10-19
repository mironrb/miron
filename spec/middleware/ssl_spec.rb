require 'spec_helper'

describe Miron::Middleware::SSL do
  describe 'Middleware' do
    # TO ALL FUTURE READERS:
    # This middleware is tested via direct objects, due to issues I (Jon Moss) was having
    # with trying to create a localhost SSL certificate, etc.
    context 'HTTPS' do
      create_mironfile_ssl(SpecHelper.temporary_directory)
      @mironfile = Miron::Mironfile.from_file(SpecHelper.temporary_directory + 'Mironfile4.rb')
      miron_request = { 'HTTPS' => true }
      response = Miron::RequestFetcher.new(miron_request, @mironfile).fetch_response

      it 'returns the correct HTTP body' do
        expect(response.body).to eq('hi')
      end

      it 'returns the correct HTTP cookies' do
        expect(response.cookies['HELLO']).to eq('HELLO')
      end

      it 'returns the correct HTTP headers' do
        expect(response.headers['HELLO']).to eq('HELLO')
      end

      it 'returns the correct HTTP status' do
        expect(response.http_status).to eq(200)
      end
    end

    context 'HTTP_X_FORWARDED_PROTO' do
      create_mironfile_ssl(SpecHelper.temporary_directory)
      @mironfile = Miron::Mironfile.from_file(SpecHelper.temporary_directory + 'Mironfile4.rb')
      miron_request = { 'HTTPS' => false, 'HTTP_X_FORWARDED_PROTO' => 'https' }
      response = Miron::RequestFetcher.new(miron_request, @mironfile).fetch_response

      it 'returns the correct HTTP body' do
        expect(response.body).to eq('hi')
      end

      it 'returns the correct HTTP cookies' do
        expect(response.cookies['HELLO']).to eq('HELLO')
      end

      it 'returns the correct HTTP headers' do
        expect(response.headers['HELLO']).to eq('HELLO')
      end

      it 'returns the correct HTTP status' do
        expect(response.http_status).to eq(200)
      end
    end

    context 'HTTP --> GET' do
      create_mironfile_ssl(SpecHelper.temporary_directory)
      @mironfile = Miron::Mironfile.from_file(SpecHelper.temporary_directory + 'Mironfile4.rb')
      miron_request = { 'HTTPS' => false, 'HTTP_HOST' => 'localhost:9295', 'HTTP_METHOD' => 'GET', 'PATH' => '/hello' }
      response = Miron::RequestFetcher.new(miron_request, @mironfile).fetch_response

      it 'returns the correct HTTP body' do
        expect(response.body).to eq('')
      end

      it 'returns the correct HTTP headers' do
        expect(response.headers['Location']).to eq('https://localhost:9295/hello')
      end

      it 'returns the correct HTTP status' do
        expect(response.http_status).to eq(301)
      end
    end

    context 'HTTP --> HEAD' do
      create_mironfile_ssl(SpecHelper.temporary_directory)
      @mironfile = Miron::Mironfile.from_file(SpecHelper.temporary_directory + 'Mironfile4.rb')
      miron_request = { 'HTTPS' => false, 'HTTP_HOST' => 'localhost:9295', 'HTTP_METHOD' => 'HEAD', 'PATH' => '/hello' }
      response = Miron::RequestFetcher.new(miron_request, @mironfile).fetch_response

      it 'returns the correct HTTP body' do
        expect(response.body).to eq('')
      end

      it 'returns the correct HTTP headers' do
        expect(response.headers['Location']).to eq('https://localhost:9295/hello')
      end

      it 'returns the correct HTTP status' do
        expect(response.http_status).to eq(301)
      end
    end

    context 'HTTP --> POST' do
      create_mironfile_ssl(SpecHelper.temporary_directory)
      @mironfile = Miron::Mironfile.from_file(SpecHelper.temporary_directory + 'Mironfile4.rb')
      miron_request = { 'HTTPS' => false, 'HTTP_HOST' => 'localhost:9295', 'HTTP_METHOD' => 'POST', 'PATH' => '/hello' }
      response = Miron::RequestFetcher.new(miron_request, @mironfile).fetch_response

      it 'returns the correct HTTP body' do
        expect(response.body).to eq('')
      end

      it 'returns the correct HTTP headers' do
        expect(response.headers['Location']).to eq('https://localhost:9295/hello')
      end

      it 'returns the correct HTTP status' do
        expect(response.http_status).to eq(307)
      end
    end
  end
end
