module Miron
  class Command
    class Server < Command
      self.summary = 'Start a Miron-backed server.'
      self.description = 'Start a Miron-backed server.'

      def self.options
        [
          ['--port=PORT', 'Port to run the Mironfile on']
        ].concat(super)
      end

      def initialize(argv)
        @mironfile = Miron::Utils.mironfile(Pathname.pwd)
        @options = {}
        @options[:port] = argv.option('port') || '9290'
        super
      end

      def validate!
        super
        help! 'No Mironfile found in directory' if Miron::Utils.mironfile_in_dir(Pathname.pwd) == false
      end

      def run
        Miron::Server.new(@mironfile, @options)
      end
    end
  end
end
