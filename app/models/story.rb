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

class Story < ActiveRecord::Base
  after_create :create_in_design_doc

  belongs_to :user
  has_one :in_design_doc, dependent: :destroy

  validates_length_of :authors_name, :maximum => 25, on: :update
  validate :text, :validate_text_count, on: :update

  def to_param
    self.user.username
  end

  protected

  def validate_text_count
    count = Validator.story_count(text)
    errors.add(:story, "length is currently #{count}. It must be less than 3000 characters") unless count < 3000
  end

  def create_in_design_doc
    InDesignDoc.create(story_id: self.id)
  end
end
