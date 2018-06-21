class Item < ApplicationRecord
  belongs_to :category
  belongs_to :section, required: false
  has_many_attached :images
end
