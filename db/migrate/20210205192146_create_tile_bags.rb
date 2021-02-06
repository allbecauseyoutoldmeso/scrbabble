class CreateTileBags < ActiveRecord::Migration[6.1]
  def change
    create_table :tile_bags do |t|
      t.references :game
    end
  end
end
