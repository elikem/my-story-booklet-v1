# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  username               :string
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  confirmation_token     :string
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string
#  failed_attempts        :integer          default(0), not null
#  unlock_token           :string
#  locked_at              :datetime
#  created_at             :datetime
#  updated_at             :datetime
#  admin                  :boolean          default(FALSE)
#

class User < ActiveRecord::Base
  before_validation :downcase_username
  after_create :create_story, :notify_slack

  has_one :story, dependent: :destroy

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  # Appears that validation of email is done by devise already
  # validates_uniqueness_of :email, :case_sensitive => false
  validates_uniqueness_of :username, :case_sensitive => false
  validates_presence_of :username

  validate :username_character_set

  protected

  def create_story
    Story.create(user_id: self.id)
  end

  def username_character_set
    if username.present? and not username.match(/^[a-z0-9_-]+$/)
      errors.add :username, "can only include letters, numbers, dashes, and underscores"
    end
  end

  def self.search(search)
    if search
      where(['username LIKE ?', "%#{search}%"])
    else
      where(nil)
    end
  end

  # Downcase username before submission
  def downcase_username
    self.username.downcase!
  end

  def notify_slack
    SLACK_NOTIFIER.ping "#{Time.zone.now.localtime.strftime('%Y-%m-%d %H:%M:%S')} -- Account created for #{self.username}"
  end
end
