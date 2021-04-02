require 'test_helper'

class CouponFlowTest < ActionDispatch::IntegrationTest
  def setup
    user = User.create!(email: 'meu.email@iugu.com.br', password: '123456')
    promotion = Promotion.create!(name: 'Natal',
                                  description: 'Promoção de Natal',
                                  code: 'NATAL10',
                                  discount_rate: 15,
                                  coupon_quantity: 5,
                                  expiration_date: '22/12/2033',
                                  user: user)
    promotion.generate_coupons!
    @coupon = promotion.coupons[0]
  end

  test 'cannot disable a coupon without login' do
    post disable_coupon_path(@coupon)
    assert_redirected_to new_user_session_path
  end

  test 'cannot activate a coupon without login' do
    @coupon.disabled!

    post activate_coupon_path(@coupon)
    assert_redirected_to new_user_session_path
  end

  test 'cannot search a coupon without login' do
    get search_coupons_path, params: { code: @coupon.code }

    assert_redirected_to new_user_session_path
end
end