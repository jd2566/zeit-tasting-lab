class Match < ApplicationRecord
  belongs_to :category
  has_many :match_section_ships
  has_many :sections, through: :match_section_ships
  has_many :item_match_ships
  has_many :items, through: :item_match_ships
end
