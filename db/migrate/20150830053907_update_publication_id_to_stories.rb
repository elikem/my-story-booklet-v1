class UpdatePublicationIdToStories < ActiveRecord::Migration
  def change
    change_column :stories, :publication_id, :string
  end
end
