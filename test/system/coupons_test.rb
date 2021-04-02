require 'application_system_test_case'

class CouponsTest < ApplicationSystemTestCase
  test 'disable a coupon' do
    user = login_user
    promotion = Promotion.create!(name: 'Natal',
                                  description: 'Promoção de Natal',
                                  code: 'NATAL10',
                                  discount_rate: 10,
                                  coupon_quantity: 3,
                                  expiration_date: '22/12/2033',
                                  user: user)

    promotion.generate_coupons!
    coupon = promotion.coupons[0]
    
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


  test 'enable a disabled coupon' do
    user = login_user
    promotion = Promotion.create!(name: 'Natal',
                                  description: 'Promoção de Natal',
                                  code: 'NATAL10',
                                  discount_rate: 10,
                                  coupon_quantity: 3,
                                  expiration_date: '22/12/2033',
                                  user: user)

    promotion.generate_coupons!
    coupon = promotion.coupons[0]
    coupon.disabled!

    
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

  test 'search a coupon with success' do
    user = login_user
    promotion = Promotion.create!(name: 'Natal',
                                  description: 'Promoção de Natal',
                                  code: 'NATAL10',
                                  discount_rate: 10,
                                  coupon_quantity: 3,
                                  expiration_date: '22/12/2033',
                                  user: user)

    promotion.generate_coupons!
    coupon = promotion.coupons[1]

    visit root_path
    click_on 'Buscar Cupom'
    fill_in 'Código', with: coupon.code
    click_on 'Buscar'

    assert_current_path coupon_path(coupon)
    assert_text 'NATAL10-0002'
    assert_text 'Ativo'
    assert_text 'Promoção de Natal'
    assert_text '10,00%'
    assert_text '22/12/2033'
  end

  test 'search a coupon without success' do
    user = login_user
    promotion = Promotion.create!(name: 'Natal',
                                  description: 'Promoção de Natal',
                                  code: 'NATAL10',
                                  discount_rate: 10,
                                  coupon_quantity: 3,
                                  expiration_date: '22/12/2033',
                                  user: user)

    promotion.generate_coupons!
    coupon = promotion.coupons[1]

    visit root_path
    click_on 'Buscar Cupom'
    fill_in 'Código', with: 'inexistente'
    click_on 'Buscar'

    assert_current_path root_path
    assert_text 'Cupom não encontrado'
  end

  test 'cannot see a coupon without login' do
    user = User.create!(email: 'meu.email@iugu.com.br', password: '123456')
    promotion = Promotion.create!(name: 'Natal',
                                  description: 'Promoção de Natal',
                                  code: 'NATAL10',
                                  discount_rate: 10,
                                  coupon_quantity: 3,
                                  expiration_date: '22/12/2033',
                                  user: user)

    promotion.generate_coupons!
    coupon = promotion.coupons[1]

    visit coupon_path(coupon)

    assert_current_path new_user_session_path
  end
end
