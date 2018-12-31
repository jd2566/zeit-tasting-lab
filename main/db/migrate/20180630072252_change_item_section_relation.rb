class ChangeItemSectionRelation < ActiveRecord::Migration[5.2]
  def change
    remove_reference(:items, :section, index: true)
  end
end
