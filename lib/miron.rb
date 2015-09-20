require 'pathname'
require 'active_support/core_ext/string/strip'

require 'miron/version'

# Miron: The Gem, The Myth, The Legend
#
module Miron
  autoload :Command,  'miron/command'
  autoload :Handler,  'miron/handler'
  autoload :Response, 'miron/response'
  autoload :Server,   'miron/server'
  autoload :Utils,    'miron/utils'

  class Handler
    autoload :WEBrick, 'miron/handlers/webrick'
  end
end
