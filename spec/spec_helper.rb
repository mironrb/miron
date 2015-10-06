$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'miron'
require 'claide'
require 'fileutils'
require 'pry'
require 'httparty'

ROOT = Pathname.new(File.expand_path('../../', __FILE__))
Dir[ROOT.join('spec/support/**/*.rb')].each { |f| require f }

ENV['TEST'] = 'true'

def create_mironfile(dir)
  (dir + 'Mironfile.rb').open('w') do |f|
    f << "class Hi
  def self.call(request, response)
    response.http_status = 200
    response.headers = { 'HELLO' => 'HELLO'}
    response.body = 'hi'
    response.cookies = { 'HELLO' => 'HELLO' }
    return response
  end
end

run Hi"
  end
end

def get
  HTTParty.get('http://0.0.0.0:9290')
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
