class CreateMatches < ActiveRecord::Migration[5.2]
  def change
    create_table :matches do |t|
      t.belongs_to :categories, foreign_key: true
      t.belongs_to :sections, foreign_key: true, optional: true
      t.string :name
      t.text   :detail
      t.string :how_to

      t.timestamps
    end
  end
end
