class CreateItemMatchShips < ActiveRecord::Migration[5.2]
  def change
    create_table :item_match_ships do |t|
      t.belongs_to :items, foreign_key: true
      t.belongs_to :matches, foreign_key: true
      t.integer :quantity
      t.string  :unit, limit: 10

      t.timestamps
    end
  end
end
