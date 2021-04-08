require 'application_system_test_case'

class PromotionsAutenticationTest < ApplicationSystemTestCase
  test 'do not view promotion link without login' do
    visit root_path

    assert_no_link 'Promoções', exact: true
  end

  test 'do not view promotions using route without login' do
    visit promotions_path

    assert_current_path new_user_session_path
  end

  test 'do not view promotions details without login' do
    promotion = Fabricate(:promotion)
    visit promotion_path(promotion)

    assert_current_path new_user_session_path
  end

  test 'can not create a promotion without login' do
    visit new_promotion_path

    assert_current_path new_user_session_path
  end

  test 'can not edit promotions without login' do
    promotion = Fabricate(:promotion)
    visit edit_promotion_path(promotion)

    assert_current_path new_user_session_path
  end

  test 'can not search promotions without login' do
    visit search_promotions_path

    assert_current_path new_user_session_path
  end
end
