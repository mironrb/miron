require 'spec_helper'

describe Miron::Command::Server do
  include SpecHelper::Command

  describe 'CLI Parameters' do
    before(:each) do
      create_mironfile(SpecHelper.temporary_directory)
    end

    it 'accepts --handler as a port argument' do
      Dir.chdir(SpecHelper.temporary_directory) do
        expect { run_command('server', '--handler=webrick') }.to_not raise_error(CLAide::Help)
      end
    end

    it 'accepts --mironfile as a port argument' do
      Dir.chdir(SpecHelper.temporary_directory) do
        expect { run_command('server', '--mironfile=Mironfile.rb') }.to_not raise_error(CLAide::Help)
      end
    end

    it 'accepts --port as a port argument' do
      Dir.chdir(SpecHelper.temporary_directory) do
        expect { run_command('server', '--port=9290') }.to_not raise_error(CLAide::Help)
      end
    end
  end

  describe 'Mironfile handling' do
    context 'mironfile does not exist' do
      before do
        remove_mironfile(SpecHelper.temporary_directory)
      end

      it 'complains if no mironfile is present (with no parameter)' do
        Dir.chdir(SpecHelper.temporary_directory) do
          expect { run_command('server') }.to raise_error(CLAide::Help)
        end
      end

      it 'complains if no mironfile is present (with parameter)' do
        Dir.chdir(SpecHelper.temporary_directory) do
          expect { run_command('server', '--mironfile=lalala.rb') }.to raise_error(CLAide::Help)
        end
      end
    end
  end
end
