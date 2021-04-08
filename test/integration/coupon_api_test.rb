require 'test_helper'

class CouponApiTest < ActionDispatch::IntegrationTest
  test 'show coupon' do
    coupon = Fabricate(:coupon, code: 'NATAL10-0001')

    get "/api/v1/coupons/#{coupon.code}", as: :json

    assert_response :success
    body = JSON.parse(response.body, symbolize_names: true)
    assert_equal coupon.discount_rate.to_s, body[:discount_rate]
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
