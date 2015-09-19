$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'miron'
require 'claide'
require 'fileutils'

ROOT = Pathname.new(File.expand_path('../../', __FILE__))
Dir[ROOT.join('spec/support/**/*.rb')].each { |f| require f }

def create_mironfile(dir)
  (dir + 'Mironfile').open('w') { |f| f << 'hello' }
end

def remove_mironfile(dir)
  if (dir + 'Mironfile').exist?
    FileUtils.rm(dir + 'Mironfile')
  else
    true
  end
end

module SpecHelper
  def self.temporary_directory
    ROOT + 'tmp'
  end
end
