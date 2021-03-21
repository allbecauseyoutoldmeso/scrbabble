class AddFinishedToGames < ActiveRecord::Migration[6.1]
  def change
    add_column :games, :finished, :boolean, default: false
  end
end
