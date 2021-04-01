require 'test_helper'

class CouponApiTest < ActionDispatch::IntegrationTest
  test 'show coupon' do
    user = User.create!(email: 'meu.email@iugu.com.br', password: '123456')
    promotion = Promotion.create!(name: 'Natal',
                                  description: 'Promoção de Natal',
                                  code: 'NATAL10',
                                  discount_rate: 15,
                                  coupon_quantity: 5,
                                  expiration_date: '22/12/2033',
                                  user: user)
    promotion.create_promotion_approval(
      user: User.create!(email: 'john.mail@iugu.com.br', password: '123456')
    )
    promotion.generate_coupons!
    coupon = promotion.coupons[0]

    get "api/v1/coupons/#{coupon.code}"

    assert_response :success
  end
end