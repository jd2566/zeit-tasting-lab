class CreateItemMatchShips < ActiveRecord::Migration[5.2]
  def change
    create_table :item_match_ships do |t|
      t.belongs_to :item, foreign_key: true
      t.belongs_to :match, foreign_key: true
      t.integer :quantity
      t.string :unit, limit: 10

      t.timestamps
    end
  end
end
