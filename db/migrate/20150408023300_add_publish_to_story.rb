class AddPublishToStory < ActiveRecord::Migration
  def change
    add_column :stories, :publish, :boolean
    add_column :stories, :publish_date, :date
  end
end
