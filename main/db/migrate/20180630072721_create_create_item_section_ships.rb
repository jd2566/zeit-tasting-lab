class CreateCreateItemSectionShips < ActiveRecord::Migration[5.2]
  def change
    create_table :item_section_ships do |t|
      t.belongs_to :item, foreign_key: true
      t.belongs_to :section, foreign_key: true

      t.timestamps
    end
  end
end
