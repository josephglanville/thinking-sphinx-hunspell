require 'ffi/hunspell'
require 'thinking_sphinx'
require 'thinking_sphinx/hunspell/configuration'

module ThinkingSphinx
  # Module for adding suggestion support into Thinking Sphinx. This gets
  # included into ThinkingSphinx::Search.
  # 
  # @author Joseph Glanville
  # 
  module Hunspell
    # The original query, with words considered mispelt replaced with the first
    # suggestion from Hunspell.
    # 
    # @return [String] the suggested query
    # 
    def suggestion
      @suggestion ||= all_args.gsub(/[\w\']+/) { |word| corrected_word(word) }
    end
    
    # An indication of whether there are any spelling corrections for the
    # original query.
    # 
    # @return [Boolean] true if the suggested query is different from the
    #   original
    # 
    def suggestion?
      suggestion != all_args
    end
    
    # Modifies the current search object, switching queries and removing any
    # previously stored results.
    # 
    def redo_with_suggestion
      @query      = nil
      @args       = [suggestion]
      @populated  = false
    end
    
    private
    
    # The search query as a single string, excluding any field-focused values
    # provided using the :conditions option.
    # 
    # @return [String] all query arguments joined together by spaces.
    # 
    def all_args
      args.join(' ')
    end
    
    # The first spelling suggestion, if the given word is considered incorrect,
    # otherwise the word is returned unchanged.
    # 
    # @param [String] word The word to check.
    # @return [String] Spelling correction for the given word.
    # 
    def corrected_word(word)
      speller.check(word) ? word : speller.suggest(word).first
    end
    
    # Hunspell::Dictionary instance
    # 
    # @return [Hunspell::Dictionary]
    # 
    def speller
      ThinkingSphinx::Configuration.instance.hunspell.speller
    end
  end
end

ThinkingSphinx::Search.send(:include, ThinkingSphinx::Hunspell)
