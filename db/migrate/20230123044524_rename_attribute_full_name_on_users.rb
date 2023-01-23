class RenameAttributeFullNameOnUsers < ActiveRecord::Migration[7.0]
  def up
    rename_column :users, :full_name, :name
  end

  def down
    rename_column :users, :name, :full_name
  end
end
