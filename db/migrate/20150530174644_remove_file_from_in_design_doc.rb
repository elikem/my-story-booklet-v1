class RemoveFileFromInDesignDoc < ActiveRecord::Migration
  def change
    remove_column :in_design_docs, :file
  end
end
