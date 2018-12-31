class ItemMatchShip < ApplicationRecord
  belongs_to :item
  belongs_to :match
end
