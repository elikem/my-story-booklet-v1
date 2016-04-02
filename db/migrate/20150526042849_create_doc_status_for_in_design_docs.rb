class CreateDocStatusForInDesignDocs < ActiveRecord::Migration
  def change
    create_table :status_for_in_design_docs do |t|
      add_column :in_design_docs, :status, :text
    end
  end
end
