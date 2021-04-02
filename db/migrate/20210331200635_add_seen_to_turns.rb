class AddSeenToTurns < ActiveRecord::Migration[6.1]
  def change
    add_column :turns, :seen, :boolean, default: false
  end
end
