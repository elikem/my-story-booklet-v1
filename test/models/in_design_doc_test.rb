# == Schema Information
#
# Table name: in_design_docs
#
#  id         :integer          not null, primary key
#  story_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  status     :string
#  idml       :string
#  epub       :string
#  pdf        :string
#

require 'test_helper'

class InDesignDocTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
