class Match < ApplicationRecord
  belongs_to :categories
  has_many :match_section_ships
  has_many :sections, through: :match_section_ships
end
