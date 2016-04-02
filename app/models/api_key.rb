# == Schema Information
#
# Table name: api_keys
#
#  id         :integer          not null, primary key
#  name       :string
#  key        :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  active     :boolean          default(TRUE)
#

class ApiKey < ActiveRecord::Base
  validates_uniqueness_of :name
  validates_presence_of :name
  validates_uniqueness_of :key

  def self.create_key(name)
    ApiKey.create(name: name, key: SecureRandom.urlsafe_base64)
  end

  def self.generate_key(name)
    @api_key = ApiKey.find_by_name(name)

    if @api_key
      @api_key.key = SecureRandom.urlsafe_base64
      @api_key.save
    end
  end

  def self.deactivate_key(name)
    @api_key = ApiKey.find_by_name(name)

    if @api_key
      @api_key.active = false
      @api_key.save
    end
  end

  def self.activate_key(name)
    @api_key = ApiKey.find_by_name(name)

    if @api_key
      @api_key.active = true
      @api_key.save
    end
  end

  def self.delete_key(name)
    @api_key = ApiKey.find_by_name(name)

    if @api_key
      @api_key.destroy
    end
  end
end
