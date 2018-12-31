class Tag < ApplicationRecord
  belongs_to :items
  belongs_to :matches
end
