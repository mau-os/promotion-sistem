class ProductCategory < ApplicationRecord
  validates :name, :code, presence: true
  validates :code, :name, uniqueness: true

  has_many :promotion_product_categories, dependent: :restrict_with_error
  has_many :promotions, through: :promotions_product_categories
end
