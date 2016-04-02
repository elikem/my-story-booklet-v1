class TextCleaner
  require 'sanitize'

  def self.clean_story(text)
    # remove all HTML tags except br
    text = Sanitize.clean(text, :elements => ['br']).strip
    # removes all spaces between <br>
    text = text.gsub(/\s+<br>\s+/, '<br>')
    # prepare XML in the InDesign format
    text = text.gsub('<br>', '</Content><Br /><Content>')
  end
end