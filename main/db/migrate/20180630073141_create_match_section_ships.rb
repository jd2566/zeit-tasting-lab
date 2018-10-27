class CreateMatchSectionShips < ActiveRecord::Migration[5.2]
  def change
    create_table :match_section_ships do |t|
      t.belongs_to :match, foreign_key: true
      t.belongs_to :section, foreign_key: true

      t.timestamps
    end
  end
end
