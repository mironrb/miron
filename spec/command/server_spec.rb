require 'spec_helper'

describe Miron::Command::Server do
  include SpecHelper::Command

  before(:each) do
    create_mironfile(SpecHelper.temporary_directory)
  end

  context 'mironfile exists' do
    it 'accepts --port as a port argument' do
      Dir.chdir(SpecHelper.temporary_directory) do
        expect { run_command('server', '--port=9290') }.to_not raise_error(CLAide::Help)
      end
    end
  end

  context 'mironfile does not exist' do
    it 'complains if no mironfile is present' do
      Dir.chdir(SpecHelper.temporary_directory) do
        remove_mironfile(SpecHelper.temporary_directory)
        expect { run_command('server', '--port=9290') }.to raise_error(CLAide::Help)
      end
    end
  end
end
