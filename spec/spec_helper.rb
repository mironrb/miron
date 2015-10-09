$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'miron'
require 'claide'
require 'fileutils'
require 'pry'
require 'httparty'

ROOT = Pathname.new(File.expand_path('../../', __FILE__))
Dir[ROOT.join('spec/support/**/*.rb')].each { |f| require f }

ENV['TEST'] = 'true'

def get
  HTTParty.get('http://0.0.0.0:9290')
end

def get_basic_auth(auth:)
  if auth == true
    credentials = { username: 'hello', password: 'hello' }
    port = '9290'
  else
    credentials = nil
    port = '9291'
  end

  HTTParty.get("http://0.0.0.0:#{port}", basic_auth: credentials)
end

def remove_mironfile(dir)
  if (dir + 'Mironfile.rb').exist?
    FileUtils.rm(dir + 'Mironfile.rb')
  else
    true
  end
end

module SpecHelper
  def self.temporary_directory
    ROOT + 'tmp'
  end
end
