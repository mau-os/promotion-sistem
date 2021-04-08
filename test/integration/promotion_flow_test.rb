require 'test_helper'

class PromotionFlowTest < ActionDispatch::IntegrationTest
  test 'can create a promotion' do
    login_user
    post promotions_path, params: {
      promotion: {
        name: 'Natal',
        description: 'Promoção de Natal',
        code: 'NATAL10',
        discount_rate: 15,
        coupon_quantity: 5,
        expiration_date: '22/12/2033'
      }
    }

    assert_redirected_to promotion_path(Promotion.last)
    assert_response :found
    follow_redirect!
    assert_select 'h3', 'Natal'
  end

  test 'cannot create a promotion without login' do
    post promotions_path, params: {
      promotion: {
        name: 'Natal',
        description: 'Promoção de Natal',
        code: 'NATAL10',
        discount_rate: 15,
        coupon_quantity: 5,
        expiration_date: '22/12/2033'
      }
    }

    assert_redirected_to new_user_session_path
  end

  test 'cannot generate coupons without login' do
    promotion = Fabricate(:promotion)

    post generate_coupons_promotion_path(promotion)
    assert_redirected_to new_user_session_path
  end

  test 'cannot edit promotions without login' do
    promotion = Fabricate(:promotion)

    patch promotion_path(promotion), params: {
      promotion: {
        name: 'Natal alterado',
        description: 'Promoção de Natal',
        code: 'NATAL10',
        discount_rate: 15,
        coupon_quantity: 5,
        expiration_date: '22/12/2033'
      }
    }
    assert_redirected_to new_user_session_path
  end

  test 'cannot delete a promotion without login' do
    promotion = Fabricate(:promotion)

    delete promotion_path(promotion)
    assert_redirected_to new_user_session_path
  end

  test 'cannot approve without login' do
    promotion = Fabricate(:promotion)

    post approve_promotion_path(promotion)
    assert_redirected_to new_user_session_path
  end

  test 'cannot approve if owner' do
    user = login_user
    promotion = Fabricate(:promotion, user: user)

    post approve_promotion_path(promotion)
    assert_redirected_to promotion_path(promotion)
    assert_not promotion.reload.approved?
    assert_equal 'Ação não permitida', flash[:alert]
  end
end
