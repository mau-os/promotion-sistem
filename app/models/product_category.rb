class ProductCategory < ApplicationRecord
  validates :name, :code, presence: true
  validates :code, :name, uniqueness: true
end
