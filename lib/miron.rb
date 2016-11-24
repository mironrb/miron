require 'pathname'
require 'active_support/core_ext/string/strip'
require 'active_support/core_ext/string/inflections'
require 'multi_json'

require 'miron/version'

# Miron: The Gem, The Myth, The Legend
#
module Miron
  HTTP_1_1 = 'HTTP-1-1'.freeze
  HTTP_2_0 = 'HTTP-2-0'.freeze

  autoload :Command,   'miron/command'
  autoload :Handler,   'miron/handler'
  autoload :Mironfile, 'miron/mironfile'
  autoload :Response,  'miron/response'
  autoload :Request,   'miron/request'
  autoload :RequestFetcher, 'miron/request_fetcher'
  autoload :Server,    'miron/server'
  autoload :Utils,     'miron/utils'
  autoload :WebsocketConnection, 'miron/websocket_connection'

  module Handler
    autoload :Http2,   'miron/handlers/http2'
    autoload :Puma,    'miron/handlers/puma'
    autoload :Thin,    'miron/handlers/thin'
    autoload :Unicorn, 'miron/handlers/unicorn'
    autoload :WEBrick, 'miron/handlers/webrick'
  end

  module Middleware
    autoload :BasicAuth, 'miron/middleware/basic_auth'
    autoload :SSL,       'miron/middleware/ssl'
    autoload :Static,    'miron/middleware/static'
  end
end
