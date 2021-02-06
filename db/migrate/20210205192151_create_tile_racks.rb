class CreateTileRacks < ActiveRecord::Migration[6.1]
  def change
    create_table :tile_racks do |t|
      t.references :player
    end
  end
end
