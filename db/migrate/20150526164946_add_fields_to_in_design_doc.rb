class AddFieldsToInDesignDoc < ActiveRecord::Migration
  def change
    add_column :in_design_docs, :idml, :string
    add_column :in_design_docs, :epub, :string
    add_column :in_design_docs, :pdf, :string
  end
end
