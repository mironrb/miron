require 'spec_helper'

describe Miron::Utils do
  before(:each) do
    remove_mironfile(SpecHelper.temporary_directory)
  end

  describe '#mironfile_in_dir' do
    it 'returns true if mironfile exists' do
      Dir.chdir(SpecHelper.temporary_directory) do
        create_mironfile(SpecHelper.temporary_directory)

        expect(
          Miron::Utils.mironfile_in_dir(SpecHelper.temporary_directory)
        ).to eq(true)
      end
    end

    it 'returns false if mironfile exists' do
      Dir.chdir(SpecHelper.temporary_directory) do
        expect(
          Miron::Utils.mironfile_in_dir(SpecHelper.temporary_directory)
        ).to eq(false)
      end
    end
  end
end
