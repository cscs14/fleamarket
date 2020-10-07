class ItemImage < ApplicationRecord
  belongs_to :freemarket
  mount_uploader :image_url, ImageUploader
end