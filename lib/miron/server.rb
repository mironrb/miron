module Miron
  # Miron::Server allows HTTP responses to be sent.
  #
  class Server
    attr_reader :mironfile, :options
    attr_accessor :handler

    # @param  [Mironfile] mironfile
    #         An instance of {Miron::Mironfile} that will be powering the {Miron::Server}
    #
    # @param  [Hash] options
    #         A Hash of configuration options
    #
    # @return [Response] returns the newly created {Miron::Server}
    #
    def initialize(mironfile, options)
      @mironfile = mironfile
      @options = options
      resolve_handler
    end

    def start
      # Set options defaults and run the handler
      @options['environment'] = ENV['MIRON_ENV'] || 'development'
      @options['host'] = '0.0.0.0'
      @handler.run(@mironfile, @options)
    end

    private

    def resolve_handler
      @handler = Miron::Handler.get(@options['handler'])
    end
  end
end
