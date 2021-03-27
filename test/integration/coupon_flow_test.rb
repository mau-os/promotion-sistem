require 'test_helper'

class CouponFlowTest < ActionDispatch::IntegrationTest
  test 'cannot disable a coupon without login' do
    promotion = Promotion.create!(name: 'Natal',
                                  description: 'Promoção de Natal',
                                  code: 'NATAL10',
                                  discount_rate: 15,
                                  coupon_quantity: 5,
                                  expiration_date: '22/12/2033')
    promotion.generate_coupons!
    coupon = promotion.coupons[0]

    post disable_coupon_path(coupon)
    assert_redirected_to new_user_session_path
  end

  test 'cannot activate a coupon without login' do
    promotion = Promotion.create!(name: 'Natal',
                                  description: 'Promoção de Natal',
                                  code: 'NATAL10',
                                  discount_rate: 15,
                                  coupon_quantity: 5,
                                  expiration_date: '22/12/2033')
    promotion.generate_coupons!
    coupon = promotion.coupons[0]
    coupon.disabled!

    post activate_coupon_path(coupon)
    assert_redirected_to new_user_session_path
  end

end