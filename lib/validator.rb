class Validator
  def self.story_count(text)
    submitted_text = TextCleaner.clean_story(text)
    submitted_text.length
  end
end