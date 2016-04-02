class RemoveIdmlUrlFromStories < ActiveRecord::Migration
  def change
    remove_column :stories , :idml_url
  end
end
