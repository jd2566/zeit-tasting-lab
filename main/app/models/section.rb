class Section < ApplicationRecord
  belongs_to :menu

  has_many :item_section_ships, dependent: :destroy
  has_many :items, through: :item_section_ships

  has_many :match_section_ships, dependent: :destroy
  has_many :matches, through: :match_section_ships
end
