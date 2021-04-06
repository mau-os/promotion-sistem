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

    get "/api/v1/coupons/#{coupon.code}", as: :json

    assert_response :success
    body = JSON.parse(response.body, symbolize_names: true)
    assert_equal promotion.discount_rate.to_s, body[:discount_rate]
  end

  test 'show coupon not found' do
    get '/api/v1/coupons/0', as: :json

    assert_response :not_found
  end

  test 'route invalid without json header' do
    assert_raises ActionController::RoutingError do
      get '/api/v1/coupons/0'
    end
  end
end