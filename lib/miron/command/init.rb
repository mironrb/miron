module Miron
  class Command
    class Init < Command
      self.summary = 'Generate a Mironfile for the current directory.'
      self.description = 'Creates a Mironfile for the current directory if none currently exists.'
      self.arguments = [
      ]

      def initialize(argv)
        @mironfile_path = Pathname.pwd + 'Mironfile'
        super
      end

      def validate!
        super
        help! 'Existing Mironfile found in directory' if Miron::Utils.mironfile_in_dir(Pathname.pwd)
      end

      def run
        @mironfile_path.open('w') { |f| f << mironfile_template }
      end

      private

      # @return [String] the text of the Podfile for the provided project
      #
      def mironfile_template
        mironfile = ''
        mironfile << <<-MIRON.strip_heredoc
          # This file is used by Miron-based servers to start the application.
        MIRON

        mironfile << "\n"
      end
    end
  end
end
