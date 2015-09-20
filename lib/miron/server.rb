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
      resolve_handler
    end

    def start
      @handler.run(mironfile, options)
    end

    private

    def resolve_handler
      @handler = Miron::Handler.get(options['server'])
    end
  end
end
