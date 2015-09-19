$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'miron'
require 'claide'
require 'pathname'

ROOT = Pathname.new(File.expand_path('../../', __FILE__))
Dir[ROOT.join('spec/support/**/*.rb')].each { |f| require f }

module SpecHelper
  def self.temporary_directory
    ROOT + 'tmp'
  end
end
