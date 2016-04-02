class RemovePublishDateFromStories < ActiveRecord::Migration
  def change
    remove_column :stories, :publish_date
  end
end
