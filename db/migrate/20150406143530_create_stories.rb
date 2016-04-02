class CreateStories < ActiveRecord::Migration
  def change
    create_table :stories do |t|
      t.text :text
      t.belongs_to :user

      t.timestamps null: false
    end
  end
end
