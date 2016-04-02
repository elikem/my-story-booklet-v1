class AddActiveToApiKeys < ActiveRecord::Migration
  def change
    add_column :api_keys, :active, :boolean, default: true
  end
end
