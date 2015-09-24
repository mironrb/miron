$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'miron'
require 'claide'
require 'fileutils'
require 'pry'

ROOT = Pathname.new(File.expand_path('../../', __FILE__))
Dir[ROOT.join('spec/support/**/*.rb')].each { |f| require f }

ENV['TEST'] = 'true'

def create_mironfile(dir)
  (dir + 'Mironfile.rb').open('w') do |f|
    f << "class Hi
  def self.call(_request)
    Miron::Response.new(200, {}, 'hi')
  end
end
    run Hi"
  end
end

def get
  Net::HTTP.start('0.0.0.0', 9290) do |http|
    get = Net::HTTP::Get.new('/test', {})
    http.request(get) { |response| @status = response.code.to_i }
  end
end

def remove_mironfile(dir)
  if (dir + 'Mironfile.rb').exist?
    FileUtils.rm(dir + 'Mironfile.rb')
  else
    true
  end
end

def sample_app
  create_mironfile(SpecHelper.temporary_directory)
  @mironfile = Miron::Mironfile.from_dir(SpecHelper.temporary_directory)
  server = Miron::Server.new(@mironfile, { 'server' => 'webrick', 'port' => '9290' })
  @thread = Thread.new { server.start }
  trap(:INT) { @thread.stop }
end

module SpecHelper
  def self.temporary_directory
    ROOT + 'tmp'
  end
end
