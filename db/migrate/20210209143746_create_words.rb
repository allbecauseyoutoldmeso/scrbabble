class CreateWords < ActiveRecord::Migration[6.1]
  def change
    create_table :words do |t|
      t.references :player
    end

    add_column :tiles, :word_id, :integer
  end
end
