require 'test_helper'

class CouponFlowTest < ActionDispatch::IntegrationTest
  test 'cannot disable a coupon without login' do
    coupon = Fabricate(:coupon)
    post disable_coupon_path(coupon)
    assert_redirected_to new_user_session_path
  end

  test 'cannot activate a coupon without login' do
    coupon = Fabricate(:coupon, status: :disabled)

    post activate_coupon_path(coupon)
    assert_redirected_to new_user_session_path
  end

  test 'cannot search a coupon without login' do
    coupon = Fabricate(:coupon)
    get search_coupons_path, params: { code: coupon.code }

    assert_redirected_to new_user_session_path
  end
end
