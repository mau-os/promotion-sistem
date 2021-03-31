class Promotion < ApplicationRecord
  belongs_to :user
  has_many :coupons
  has_one :promotion_approval
  has_one :approver, through: :promotion_approval, source: :user
  
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

  def approved?
    promotion_approval.present?
  end

  def can_approve?(current_user)
    user != current_user
  end
end