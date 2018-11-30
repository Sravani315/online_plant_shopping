class Product < ApplicationRecord
  # mount_uploader :image, ImageUploader  

  belongs_to :product_type
  belongs_to :category
end
