class AddPriceColumns < ActiveRecord::Migration[5.2]
  def change
    add_column :items, :price, :integer, default: 0
    add_column :matches, :price, :integer, default: 0
  end
end
