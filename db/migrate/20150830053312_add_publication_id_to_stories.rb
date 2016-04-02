class AddPublicationIdToStories < ActiveRecord::Migration
  def change
    add_column :stories, :publication_id, :integer
  end
end
