class CreateMatches < ActiveRecord::Migration[5.2]
  def change
    create_table :matches do |t|
      t.belongs_to :category, foreign_key: true
      t.belongs_to :section, foreign_key: true
      t.string :name
      t.text :detail
      t.string :how_to

      t.timestamps
    end
  end
end
