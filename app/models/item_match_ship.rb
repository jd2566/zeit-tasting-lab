class ItemMatchShip < ApplicationRecord
  belongs_to :items
  belongs_to :matches
end
