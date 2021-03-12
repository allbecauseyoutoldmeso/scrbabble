class AddBlankToTiles < ActiveRecord::Migration[6.1]
  def change
    add_column :tiles, :blank, :boolean, default: false
  end
end
