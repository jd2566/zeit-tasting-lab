class CreateTags < ActiveRecord::Migration[5.2]
  def change
    create_table :tags do |t|
      t.belongs_to :item, foreign_key: true
      t.belongs_to :match, foreign_key: true
      t.string :name

      t.timestamps
    end
  end
end
