class ChangeStatusToString < ActiveRecord::Migration
  def change
    change_column :in_design_docs, :status, :string
  end
end
