class Menu < ApplicationRecord
  has_many :sections, dependent: :destroy
  has_many :items, through: :sections
end
