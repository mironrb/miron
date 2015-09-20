module Miron
  # Miron::Server allows HTTP responses to be sent.
  #
  class Server
    attr_reader :mironfile, :options
    attr_accessor :handler

    # @param  [String] mironfile
    #         A String of the mironfile that will be powering the {Miron::Server}
    #
    # @param  [Hash] options
    #         A Hash of configuration options
    #
    # @return [Response] returns the newly created {Miron::Response}
    #
    def initialize(mironfile, options)
      @mironfile = mironfile
      @options = options
    end

    def start
      @handler = Miron::Handler.get(options['server'])
      @handler.run
    end
  end
end
