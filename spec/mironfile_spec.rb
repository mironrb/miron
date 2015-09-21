require 'spec_helper'

describe Miron::Mironfile do
  describe '#from_dir' do
    before do
      create_mironfile(SpecHelper.temporary_directory)
    end

    it 'returns an instance of Miron::Mironfile' do
      mironfile = Miron::Mironfile.from_dir(SpecHelper.temporary_directory)
      expect(mironfile.class).to eq(Miron::Mironfile)
    end
  end
end
