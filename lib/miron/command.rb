require 'claide'

module Miron
  class Command < CLAide::Command
    require 'miron/command/init'

    self.abstract_command = true
    self.command = 'miron'
    self.version = VERSION
    self.description = 'Miron, a redesigned Ruby web interface.'
    self.plugin_prefixes = %w(claide miron)

    def self.options
      [
      ].concat(super)
    end

    def self.run(argv)
      help! 'You cannot run Miron as root.' if Process.uid == 0
      super(argv)
    end

    def initialize(argv)
      super
    end
  end
end
