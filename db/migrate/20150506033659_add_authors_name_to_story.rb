class AddAuthorsNameToStory < ActiveRecord::Migration
  def change
    add_column :stories, :authors_name, :text
    remove_column :in_design_docs, :authors_name
    remove_column :in_design_docs, :first_page_first_letter
  end
end
