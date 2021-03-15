class RenameBlank < ActiveRecord::Migration[6.1]
  def change
    rename_column :tiles, :blank, :multipotent
  end
end
