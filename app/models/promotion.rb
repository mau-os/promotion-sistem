class Promotion < ApplicationRecord
  has_many :coupons
  
  validates :name, :code, :discount_rate, :coupon_quantity,
            :expiration_date, presence: true
  validates :code, :name, uniqueness: true


  def generate_coupons!
    return if coupons?
    Coupon.transaction do
      (1..coupon_quantity).each do |number|
        coupons.create!(code: "#{code}-#{'%04d' % number}")
      end
    end
  end

  def coupons?
    coupons.any?
  end

  def self.search(query)
    where('name LIKE ?', "%#{query}%")
  end
end
