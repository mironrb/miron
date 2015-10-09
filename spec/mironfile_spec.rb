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

  describe '#from_file' do
    before do
      create_mironfile(SpecHelper.temporary_directory)
    end

    it 'returns an instance of Miron::Mironfile' do
      mironfile = Miron::Mironfile.from_file(SpecHelper.temporary_directory + 'Mironfile.rb')
      expect(mironfile.class).to eq(Miron::Mironfile)
    end
  end

  describe 'argument passing to app and middlewares' do
    context 'args' do
      before do
        create_mironfile_args(SpecHelper.temporary_directory)
      end

      it 'returns an instance of app' do
        mironfile = Miron::Mironfile.from_file(SpecHelper.temporary_directory + 'Mironfile1.rb')
        expect(mironfile.app).to be_an_instance_of(HiThree)
        expect(mironfile.app.class).to eq(HiThree)
      end

      it 'returns an instance of middleware' do
        mironfile = Miron::Mironfile.from_file(SpecHelper.temporary_directory + 'Mironfile1.rb')
        expect(mironfile.middleware.first).to be_an_instance_of(HiFour)
        expect(mironfile.middleware.first.class).to eq(HiFour)
      end
    end

    context 'no args' do
      before do
        create_mironfile(SpecHelper.temporary_directory)
      end

      it 'returns a class, not an instance of app' do
        mironfile = Miron::Mironfile.from_file(SpecHelper.temporary_directory + 'Mironfile.rb')
        expect(mironfile.app).to_not be_an_instance_of(Hi)
        expect(mironfile.app).to eq(Hi)
      end

      it 'returns an class, not an instance of middleware' do
        mironfile = Miron::Mironfile.from_file(SpecHelper.temporary_directory + 'Mironfile.rb')
        expect(mironfile.middleware.first).to_not be_an_instance_of(HiTwo)
        expect(mironfile.middleware.first).to eq(HiTwo)
      end
    end
  end
end
