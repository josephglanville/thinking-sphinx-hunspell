require 'singleton'

module ThinkingSphinx
  module Hunspell
    # Configuration settings for spelling suggestions in Thinking Sphinx. You
    # can access these either by the singleton instance
    # (ThinkingSphinx::Hunspell::Configuration.instance), or through Thinking 
    # Sphinx's existing configuration instance
    # (ThinkingSphinx::Configuration.instance.hunspell).
    # 
    # @author Joseph Glanville
    # 
    class Configuration
      include Singleton
      
      attr_accessor :dictionary
      
      # Creates the instance of the singleton with default dictionary (en_US)
      def initialize
        reset
      end
      
      # Resets the instance to the default settings. Probably not necessary in
      # general usage, but makes specs easier to run.
      def reset
        @dictionary      = 'en_US'
        @speller         = nil
      end
      
      # @param [Aspell] speller Aspell instance.
      # @raise [ArgumentError] if the speller is not an Aspell instance
      def speller=(speller)
        raise ArgumentError, 'invalid Hunspell speller' unless speller.is_a? FFI::Hunspell::Dictionary
        @speller = speller
      end

      # Configured Hunspell dictionary
      # @return [FFI::Hunspell::Dictionary]
      def speller
        @speller ||= FFI::Hunspell.dict(dictionary)
      end
    end
    
    module Hooks
      # The singleton ThinkingSphinx::Hunspell::Configuration instance.
      # @return [ThinkingSphinx::Hunspell::Configuration] config instance
      def hunspell
        ThinkingSphinx::Hunspell::Configuration.instance
      end
    end
  end
end

ThinkingSphinx::Configuration.send(:include, ThinkingSphinx::Hunspell::Hooks)
