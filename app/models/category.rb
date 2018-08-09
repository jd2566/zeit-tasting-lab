class Category < ApplicationRecord
  belongs_to :root_category
  has_many :items
  has_many :matches
end
