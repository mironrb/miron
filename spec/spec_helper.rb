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
  FileUtils.rm(dir + 'Mironfile.rb') if File.exist?(dir + 'Mironfile.rb')
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

class HiTwo
  def self.call(request, response)
  end
end

use HiTwo
run Hi"
  end
end

def create_mironfile_args(dir)
  FileUtils.rm(dir + 'Mironfile1.rb') if File.exist?(dir + 'Mironfile1.rb')
  (dir + 'Mironfile1.rb').open('w') do |f|
    f << "class HiThree
  def initialize(hi)
    @hi = hi
  end
  def call(request, response)
    response.http_status = 200
    response.headers = { 'HELLO' => 'HELLO'}
    response.body = 'hi'
    response.cookies = { 'HELLO' => 'HELLO' }
    return response
  end
end

class HiFour
  def initialize(hi)
    @hi = hi
  end
  def call(request, response)
  end
end

use HiFour, 'hi'
run HiThree, 'hi'"
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
