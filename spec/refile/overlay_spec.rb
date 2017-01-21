require 'refile/overlay'
require 'refile/spec_helper'

RSpec.describe Refile::Overlay::Backend do
  def uploadable(data = 'hello')
    Refile::FileDouble.new(data)
  end

  before do
    @primary = Refile::Backend::FileSystem.new(File.expand_path('tmp/upper', Dir.pwd), max_size: 100)
    @secondary = Refile::Backend::FileSystem.new(File.expand_path('tmp/lower', Dir.pwd), max_size: 100)
    @overlay = Refile::Overlay::Backend.new(@primary, @secondary)
  end

  let(:backend) do
    @overlay
  end

  it_behaves_like :backend

  describe '#upload' do
    it 'uploads to the primary backend' do
      file = @overlay.upload(uploadable)
      expect(@primary.exists?(file.id)).to be_truthy
      expect(@secondary.exists?(file.id)).to be_falsey
    end
  end

  describe '#exists?' do
    it 'should find files located on the secondary backend' do
      file = @secondary.upload(uploadable)
      expect(@overlay.exists?(file.id)).to be_truthy
    end
  end

  describe '#delete' do
    it 'should not delete files on the secondary backend' do
      file = @secondary.upload(uploadable)
      @overlay.delete(file.id)
      expect(@overlay.exists?(file.id)).to be_truthy
    end
  end

  describe '#clear!' do
    it 'should clear the primary backend' do
      file = @primary.upload(uploadable)
      @overlay.clear!(:confirm)
      expect(@overlay.exists?(file.id)).to be_falsey
    end

    it 'should not clear the secondary backend' do
      file = @secondary.upload(uploadable)
      @overlay.clear!(:confirm)
      expect(@overlay.exists?(file.id)).to be_truthy
    end
  end
end
