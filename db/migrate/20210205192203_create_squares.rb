class CreateSquares < ActiveRecord::Migration[6.1]
  def change
    create_table :squares do |t|
      t.integer :x
      t.integer :y
      t.references :board
    end
  end
end
