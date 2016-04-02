class CreateInDesignDocs < ActiveRecord::Migration
  def change
    create_table :in_design_docs do |t|
      t.belongs_to :story
      t.text :authors_name
      t.text :first_page_first_letter
      t.text :first_page_text
      t.text :second_and_third_page_text
      t.binary :file

      t.timestamps null: false
    end
  end
end
