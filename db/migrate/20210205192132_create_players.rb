class CreatePlayers < ActiveRecord::Migration[6.1]
  def change
    create_table :players do |t|
      t.references :game
      t.integer :points, default: 0
    end
  end
end
