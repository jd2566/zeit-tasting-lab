class CreateSections < ActiveRecord::Migration[5.2]
  def change
    create_table :sections do |t|
      t.belongs_to :menus, foreign_key: true
      t.string :name

      t.timestamps
    end
  end
end
