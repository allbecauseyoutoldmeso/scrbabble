class CreatePremiums < ActiveRecord::Migration[6.1]
  def change
    create_table :premiums do |t|
      t.references :square
      t.integer :tuple
      t.integer :target
      t.boolean :active, default: true
    end
  end
end
