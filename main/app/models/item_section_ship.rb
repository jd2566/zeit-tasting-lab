class ItemSectionShip < ApplicationRecord
  belongs_to :item
  belongs_to :section
  validates_uniqueness_of :item_id, :scope => :section_id
end
