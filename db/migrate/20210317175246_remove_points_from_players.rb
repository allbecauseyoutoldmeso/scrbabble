class RemovePointsFromPlayers < ActiveRecord::Migration[6.1]
  def change
    remove_column :players, :points
  end
end
