# == Schema Information
#
# Table name: stories
#
#  id             :integer          not null, primary key
#  text           :text
#  user_id        :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  publish        :boolean
#  authors_name   :text
#  publication_id :string
#

require 'test_helper'

class StoryTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
