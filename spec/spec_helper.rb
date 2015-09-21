$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'miron'
require 'claide'
require 'fileutils'
require 'pry'

ROOT = Pathname.new(File.expand_path('../../', __FILE__))
Dir[ROOT.join('spec/support/**/*.rb')].each { |f| require f }

def create_mironfile(dir)
  (dir + 'Mironfile').open('w') { |f| f << 'hello' }
end

def get
  Net::HTTP.start('127.0.0.1', 9290) do |http|
    get = Net::HTTP::Get.new('/test', {})
    http.request(get) { |response| @status = response.code.to_i }
  end
end

def remove_mironfile(dir)
  if (dir + 'Mironfile').exist?
    FileUtils.rm(dir + 'Mironfile')
  else
    true
  end
end

class Hi
  def call(_request)
    Miron::Response.new(200, {}, 'hi')
  end
end

def sample_app
  app = Hi
  server = Miron::Server.new(app, { 'server' => 'webrick', 'port' => '9290' })
  @thread = Thread.new { server.start }
  trap(:INT) { @thread.stop }
end

module SpecHelper
  def self.temporary_directory
    ROOT + 'tmp'
  end
end
