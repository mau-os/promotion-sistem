require 'application_system_test_case'

class CouponsTest < ApplicationSystemTestCase
  test 'disable a coupon' do
    promotion = Promotion.create!(name: 'Natal',
                                  description: 'Promoção de Natal',
                                  code: 'NATAL10',
                                  discount_rate: 10,
                                  coupon_quantity: 3,
                                  expiration_date: '22/12/2033')

    promotion.generate_coupons!
    coupon = promotion.coupons[0]
    
    login_user
    visit promotion_path(promotion)
    within "div#coupon-#{coupon.code.parameterize}" do
      click_on 'Desabilitar'
    end

    assert_text "Cupom #{coupon.code} desabilitado com sucesso"
    assert_text "#{coupon.code} (desabilitado)"
    within "div#coupon-#{coupon.code.parameterize}" do
      assert_no_link 'Desabilitar'
    end
    assert_link 'Desabilitar', count: promotion.coupon_quantity - 1
  end


  test 'enable a activate coupon' do
    promotion = Promotion.create!(name: 'Natal',
                                  description: 'Promoção de Natal',
                                  code: 'NATAL10',
                                  discount_rate: 10,
                                  coupon_quantity: 3,
                                  expiration_date: '22/12/2033')

    promotion.generate_coupons!
    coupon = promotion.coupons[0]
    coupon.disabled!

    
    login_user
    visit promotion_path(promotion)
    within "div#coupon-#{coupon.code.parameterize}" do
      click_on 'Ativar'
    end

    assert_text "Cupom #{coupon.code} ativado com sucesso"
    assert_text "#{coupon.code}"
    assert_no_text "#{coupon.code} (desabilitado)"
    within "div#coupon-#{coupon.code.parameterize}" do
      assert_no_link 'Ativar'
    end
    assert_link 'Desabilitar', count: promotion.coupon_quantity
  end
end
