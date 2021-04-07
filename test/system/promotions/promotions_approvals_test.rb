require 'application_system_test_case'

class PromotionsApprovalsTest < ApplicationSystemTestCase
  test 'user approve promotion' do
    user = User.create!(email: 'john.mail@iugu.com.br', password: '112233')
    promotion = Promotion.create!(name: 'Natal',
                                  description: 'Promoção de Natal',
                                  code: 'NATAL10',
                                  discount_rate: 10,
                                  coupon_quantity: 100,
                                  expiration_date: '22/12/2033',
                                  user: user)

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
    promotion = Promotion.create!(name: 'Natal',
                                  description: 'Promoção de Natal',
                                  code: 'NATAL10',
                                  discount_rate: 10,
                                  coupon_quantity: 100,
                                  expiration_date: '22/12/2033',
                                  user: user)

    visit promotion_path(promotion)

    refute_link 'Aprovar'
  end
end