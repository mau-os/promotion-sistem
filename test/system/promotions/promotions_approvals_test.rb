require 'application_system_test_case'

class PromotionsApprovalsTest < ApplicationSystemTestCase
  test 'user approve promotion' do
    promotion = Fabricate(:promotion)

    approver = login_user
    visit promotion_path(promotion)
    assert_emails 1 do
      accept_confirm { click_on 'Aprovar' }
      assert_text 'Promoção aprovada com sucesso'
    end

    assert_text "Aprovada por: #{approver.email}"
    assert_link 'Gerar cupons'
    refute_link 'Aprovar'
      
  end

  test 'user can not approve his promotion' do
    user = login_user
    promotion = Fabricate(:promotion, user: user)

    visit promotion_path(promotion)

    refute_link 'Aprovar'
  end
end