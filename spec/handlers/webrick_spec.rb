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
    #before do
      #Thread.list(&:exit)
      #create_mironfile(SpecHelper.temporary_directory)
      #@mironfile = Miron::Mironfile.from_dir(SpecHelper.temporary_directory)
      #server = Miron::Server.new(@mironfile, { 'handler' => 'webrick', 'host' => '0.0.0.0', 'server' => 'webrick', 'port' => '9290' })
      #@thread = Thread.new { server.start }
      #trap(:INT) { @thread.exit }
    #end
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
