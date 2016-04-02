class ChangePublishDateInStories < ActiveRecord::Migration
  def change
    change_column :stories, :publish_date, :datetime
  end
end
