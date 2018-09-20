class Item < ApplicationRecord
  include Rails.application.routes.url_helpers
  belongs_to :category
  has_many :item_section_ships
  has_many :sections, through: :item_section_ships
  has_many :item_match_ships
  has_many :matches, through: :item_match_ships

  has_many_attached :images

  def json
    {
      id: id,
      category_id: category_id,
      name: name,
      price: price,
      eng: eng,
      jpn: jpn,
      detail: detail,
      eng_detail: eng_detail,
      jpn_detail: jpn_detail,
      images: images.map.with_index { |im, index|
        {
          id: im.id,
          name: im.filename,
          url: rails_blob_path(im.variant(resize: "480x480").processed.blob, only_path: true)
        }
      }
    }
  end

  def simple_json
    {
      id: id,
      category_id: category_id,
      name: name,
      eng: eng,
      jpn: jpn,
      image: {
        id: images.first.present? ? images.first.id : nil,
        url: images.first.present? ? rails_blob_path(images.first.variant(resize: "480x480").processed.blob, only_path: true) : "/images/zeit.jpg"
      }
    }
  end
end
