require 'spec_helper'

describe ThinkingSphinx::Configuration do
  describe '#hunspell' do
    before :each do
      @config = ThinkingSphinx::Configuration.instance
    end

    it "should return a hunspell configuration instance" do
      expect(@config.hunspell).to be_a(ThinkingSphinx::Hunspell::Configuration)
    end
  end
end

describe ThinkingSphinx::Hunspell::Configuration do
  before :each do
    @config = ThinkingSphinx::Hunspell::Configuration.instance
    @config.reset
  end

  describe '#dictionary' do
    it "should default to 'en_US'" do
      expect(@config.dictionary).to eq('en_US')
    end
  end

  describe '#dictionary=' do
    it "should set the dictionary" do
      @config.dictionary = 'en_GB'
      expect(@config.dictionary).to eq('en_GB')
    end
  end

  describe '#speller' do
    it "should return an FFI::Hunspell::Dictionary instance" do
      expect(@config.speller).to be_an(FFI::Hunspell::Dictionary)
    end

    it "should use the configured dictionary" do
      speller = FFI::Hunspell.dict('en_GB')
      expect(FFI::Hunspell).to receive(:dict).with('en_GB').
        and_return(speller)

      @config.dictionary = 'en_GB'
      @config.speller
    end


    it "should reuse the generated instance" do
      expect(FFI::Hunspell).to receive(:dict).once.and_return(
        double('speller').as_null_object
      )

      @config.speller
      @config.speller
    end
  end

  describe "#speller=" do
    it "should set the speller" do
      hunspell = FFI::Hunspell.dict('en_US')

      @config.speller = hunspell
      expect(@config.speller).to eq(hunspell)
    end

    it "should raise an arguement error if the speller is not an FFI::Hunspell::Dictionary instance" do
      expect { @config.speller = 'Hunspell' }.to raise_error(ArgumentError)
    end
  end
end
