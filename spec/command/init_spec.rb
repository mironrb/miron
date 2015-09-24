require 'spec_helper'

describe Miron::Command::Init do
  include SpecHelper::Command

  before(:each) do
    remove_mironfile(SpecHelper.temporary_directory)
  end

  it 'errors if a Mironfile already exists' do
    Dir.chdir(SpecHelper.temporary_directory) do
      (Pathname.pwd + 'Mironfile.rb').open('w') { |f| f << 'hello' }
      expect { run_command('init') }.to raise_error(CLAide::Help)
    end
  end

  it 'creates a Mironfile for a project in current directory' do
    Dir.chdir(SpecHelper.temporary_directory) do
      run_command('init')
      expect(
        Pathname.new(SpecHelper.temporary_directory + 'Mironfile.rb').exist?
      ).to eq(true)
    end
  end
end
