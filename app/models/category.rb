class Category < ApplicationRecord
  belongs_to :product_type
  has_many :products
end
  