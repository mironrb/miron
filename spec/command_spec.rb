require 'spec_helper'
#add some more comments you bonobo
module Miron
  describe Command do
    it 'displays the current version number with the --version flag' do
      expect(Miron::Command.version).to eq(VERSION)
    end

    it "doesn't let you run as root" do
      expect do
        -> { Miron::Command.run(['--version']) }
      end.to raise_error(CLAide::Help) if Process.uid == 0
    end
  end
end
