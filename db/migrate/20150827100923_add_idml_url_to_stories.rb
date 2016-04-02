class AddIdmlUrlToStories < ActiveRecord::Migration
  def change
    add_column :stories, :idml_url, :string
  end
end
