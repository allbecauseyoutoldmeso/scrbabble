class CreateTurns < ActiveRecord::Migration[6.1]
  def change
    create_table :turns do |t|
      t.integer :points
      t.references :game
      t.references :player
      t.timestamps
    end

    add_column :tiles, :turn_id, :integer
  end
end
