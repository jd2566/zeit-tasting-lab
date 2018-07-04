class Item < ApplicationRecord
  include Rails.application.routes.url_helpers
  belongs_to :category
  has_many :item_section_ships
  has_many :sections, through: :item_section_ships
  has_many_attached :images

  def json
    {
      id: id,
      category_id: category_id,
      name: name,
      detail: detail,
      images: images.map.with_index { |im, index|
        {
          id: im.id,
          name: im.filename,
          url: rails_blob_path(im, only_path: true)
        }
      }
    }
  end
end
