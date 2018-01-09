describe Finder do
  let(:finder) { Finder.new }

  describe "given a valid file" do
    it "performs a search" do
      result = finder.search('spec/test_files/langs.yml')
      expect(result.count).to eql(71)
    end

    it "performs a search for languages with symbols in their names" do
      result = finder.search('spec/test_files/langs_sym.yml')
      expect(result.count).to eql(29)
    end

    it "fails for a search for more than 3 languages" do
      expect{
        finder.search('spec/test_files/multiple_langs.yml')
      }.to raise_error(SystemExit)
    end

    it "fails for a non-existent language" do
      expect{
        finder.search('spec/test_files/nonexistent_langs.yml')
      }.to raise_error(SystemExit)
    end
  end

  describe "given an invalid file" do
    it "fails for a non-existent file" do
      expect{
        finder.search('spec/test_files/foo.yml')
      }.to raise_error(SystemExit)
    end

    it "fails for an invalid file" do
      expect{
        finder.search('spec/test_files/foo.txt')
      }.to raise_error(SystemExit)
    end
  end
end