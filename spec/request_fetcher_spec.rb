require 'spec_helper'

describe Miron::RequestFetcher do
  describe 'In general' do
    before do
      create_mironfile(SpecHelper.temporary_directory)
    end

    it 'can be initialized' do
      mironfile = Miron::Mironfile.from_dir(SpecHelper.temporary_directory)
      request_hash = { 'PATH_INFO' => '/', 'REQUEST_METHOD' => 'GET' }
      request_fetcher = Miron::RequestFetcher.new(request_hash, HTTP_1_1, mironfile).fetch_response

      expect(request_fetcher.class).to eq(Miron::Response)
      expect(request_fetcher).to be_an_instance_of(Miron::Response)
    end

    it 'raises on unsupported protocol' do
      mironfile = Miron::Mironfile.from_dir(SpecHelper.temporary_directory)
      request_hash = { 'PATH_INFO' => '/', 'REQUEST_METHOD' => 'GET' }

      expect do
        Miron::RequestFetcher.new(request_hash, 'HTTP-3-0', mironfile)
      end.to raise_error(RuntimeError)
    end
  end
end
