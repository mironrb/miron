module Miron
  class Command
    class Server < Command
      self.summary = 'Start a Miron-backed server.'
      self.description = 'Start a Miron-backed server.'

      def self.options
        [
          ['--port=PORT', 'Port to run the Mironfile on'],
          ['--handler=HANDLER', 'Handler to use for your Miron-backed server']
        ].concat(super)
      end

      def initialize(argv)
        @mironfile = Miron::Mironfile.from_dir(Pathname.pwd)
        @options = {}
        @options['port'] = argv.option('port') || 9290
        @options['handler'] = argv.option('handler')
        @options['mironfile_path'] = Pathname.pwd + 'Mironfile'
        super
      end

      def validate!
        super
        help! 'No Mironfile found in directory' if Miron::Utils.mironfile_in_dir(Pathname.pwd) == false
      end

      def run
        server = Miron::Server.new(@mironfile, @options)
        server.start
      end
    end
  end
end
