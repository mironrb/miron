module Miron
  class Command
    class Server < Command
      self.summary = 'Start a Miron-backed server.'
      self.description = 'Start a Miron-backed server.'

      def self.options
        [
          ['--port=PORT', 'Port to run the Mironfile on'],
          ['--handler=HANDLER', 'Handler to use for your Miron-backed server'],
          ['--mironfile=MIRONFILE', 'Path to Mironfile, if you are not planning on using a Mironfile.rb']
        ].concat(super)
      end

      def initialize(argv)
        @options = {}
        @options['port'] = argv.option('port') || 9290
        @options['handler'] = argv.option('handler')
        if argv.options.key?('mironfile')
          @options['mironfile'] = Pathname.pwd + argv.option('mironfile')
        end
        @mironfile = fetch_mironfile
        super
      end

      def validate!
        super
        help! 'No Mironfile found in directory.' unless fetch_mironfile
      end

      def run
        server = Miron::Server.new(@mironfile, @options)
        server.start
      end

      private

      def fetch_mironfile
        Miron::Mironfile.from_dir(Pathname.pwd) || Miron::Mironfile.from_file(@options['mironfile']) || nil
      end
    end
  end
end
