class AddCurrentPlayerToGame < ActiveRecord::Migration[6.1]
  def change
    add_column :games, :current_player_id, :integer
  end
end
