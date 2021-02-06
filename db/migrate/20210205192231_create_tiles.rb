class CreateTiles < ActiveRecord::Migration[6.1]
  def change
    create_table :tiles do |t|
      t.string :letter
      t.integer :points
      t.bigint :tileable_id
      t.string :tileable_type
    end
  end
end
