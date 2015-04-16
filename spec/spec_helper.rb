require 'thinking_sphinx/hunspell'

ThinkingSphinx::ActiveRecord::LogSubscriber.logger = Logger.new(StringIO.new)

RSpec.configure do |config|
  #
end
