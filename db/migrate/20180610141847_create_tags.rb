class CreateTags < ActiveRecord::Migration[5.2]
  def change
    create_table :tags do |t|
      t.belongs_to :items, foreign_key: true
      t.belongs_to :matches, foreign_key: true
      t.string :name

      t.timestamps
    end
  end
end
