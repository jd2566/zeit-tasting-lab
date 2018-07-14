class ChangeMatchRelations < ActiveRecord::Migration[5.2]
  def change
    remove_reference(:matches, :section, index: true)
  end
end
