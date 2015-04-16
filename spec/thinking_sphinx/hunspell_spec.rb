require 'spec_helper'

describe ThinkingSphinx::Search do
  before :each do
    ThinkingSphinx::Configuration.instance.hunspell.reset
  end
  
  describe '#suggestion' do
    it "should return a spelling suggestion, if there is one" do
      search = ThinkingSphinx::Search.new('wodrs incorret on purpose')
      expect(search.suggestion).to eq('words incorrect on purpose')
    end
    
    it "should be actual query if there is no suggestion" do
      search = ThinkingSphinx::Search.new('words all correct here')
      expect(search.suggestion).to eq('words all correct here')
    end
  end
  
  describe '#suggestion?' do
    it "should return true if there is a spelling suggestion" do
      search = ThinkingSphinx::Search.new('wodrs incorret on purpose')
      expect(search.suggestion?).to be_truthy
    end
    
    it "should return false if there is no spelling suggestion" do
      search = ThinkingSphinx::Search.new('words all correct here')
      expect(search.suggestion?).to be_falsey
    end
    
    it "should return false if there are conditions and no spelling suggestion" do
      search = ThinkingSphinx::Search.new('words',
        :conditions => {:all => 'here'}
      )
      expect(search.suggestion?).to be_falsey
    end
  end
  
  describe '#redo_with_suggestion' do
    before :each do
      @config = ThinkingSphinx::Configuration.instance
      @client = Riddle::Client.new

      allow(@config).to receive_messages(:client => @client)
      allow(@client).to receive_messages(:query => {:matches => [], :total_found => 0, :total => 0})
    end
    
    it "should repeat the query with the spelling suggestion" do
      expect(@client).to receive(:query) do |query, index, comment|
        expect(query).to eq('words incorrect on purpose')
      end
      
      search = ThinkingSphinx::Search.new('wodrs incorret on purpose')
      search.redo_with_suggestion
      search.first
    end
    
    it "should redo the query if it's already been populated" do
      expect(@client).to receive(:query).twice
      
      search = ThinkingSphinx::Search.new('wodrs incorret on purpose')
      search.first
      search.redo_with_suggestion
      search.first
    end
  end
end
