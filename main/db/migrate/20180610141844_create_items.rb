class CreateItems < ActiveRecord::Migration[5.2]
  def change
    create_table :menus do |t|
      t.string :name

      t.timestamps
    end

    create_table :sections do |t|
      t.belongs_to :menu, foreign_key: true
      t.string :name

      t.timestamps
    end

    create_table :items do |t|
      t.belongs_to :category, foreign_key: true
      t.belongs_to :section, foreign_key: true
      t.string :name
      t.text :detail
      t.integer :stock
      t.string :stock_unit, limit: 10

      t.timestamps
    end
  end
end
