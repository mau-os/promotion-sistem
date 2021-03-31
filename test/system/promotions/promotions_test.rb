require 'application_system_test_case'

class PromotionsTest < ApplicationSystemTestCase
  test 'view promotions' do
    user = login_user
    Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: '22/12/2033', user: user)
    Promotion.create!(name: 'Cyber Monday', coupon_quantity: 100,
                      description: 'Promoção de Cyber Monday',
                      code: 'CYBER15', discount_rate: 15,
                      expiration_date: '22/12/2033', user: user)

    visit root_path
    click_on 'Promoções'

    assert_text 'Natal'
    assert_text 'Promoção de Natal'
    assert_text '10,00%'
    assert_text 'Cyber Monday'
    assert_text 'Promoção de Cyber Monday'
    assert_text '15,00%'
  end

  test 'view promotion details' do
    user = login_user
    Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: '22/12/2033', user: user)
    Promotion.create!(name: 'Cyber Monday', coupon_quantity: 90,
                      description: 'Promoção de Cyber Monday',
                      code: 'CYBER15', discount_rate: 15,
                      expiration_date: '22/12/2033', user: user)

    visit root_path
    click_on 'Promoções'
    click_on 'Cyber Monday'

    assert_text 'Cyber Monday'
    assert_text 'Promoção de Cyber Monday'
    assert_text '15,00%'
    assert_text 'CYBER15'
    assert_text '22/12/2033'
    assert_text '90'
  end

  test 'no promotion are available' do
    login_user
    visit root_path
    click_on 'Promoções'

    assert_text 'Nenhuma promoção cadastrada'
  end

  test 'view promotions and return to home page' do
    user = login_user
    Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: '22/12/2033', user: user)

    visit root_path
    click_on 'Promoções'
    click_on 'Voltar'

    assert_current_path root_path
  end

  test 'view details and return to promotions page' do
    user = login_user
    Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: '22/12/2033', user: user)

    visit root_path
    click_on 'Promoções'
    click_on 'Natal'
    click_on 'Voltar'

    assert_current_path promotions_path
  end

  test 'create promotion' do
    login_user
    visit root_path
    click_on 'Promoções'
    click_on 'Registrar uma promoção'
    fill_in 'Nome', with: 'Cyber Monday'
    fill_in 'Descrição', with: 'Promoção de Cyber Monday'
    fill_in 'Código', with: 'CYBER15'
    fill_in 'Desconto', with: '15'
    fill_in 'Quantidade de cupons', with: '90'
    fill_in 'Data de término', with: '2033-12-22'
    click_on 'Criar Promoção'

    assert_current_path promotion_path(Promotion.last)
    assert_text 'Cyber Monday'
    assert_text 'Promoção de Cyber Monday'
    assert_text '15,00%'
    assert_text 'CYBER15'
    assert_text '22/12/2033'
    assert_text '90'
    assert_link 'Voltar'
  end

  test 'create and attributes cannot be blank' do
    login_user
    visit root_path
    click_on 'Promoções'
    click_on 'Registrar uma promoção'
    click_on 'Criar Promoção'

    assert_text 'não pode ficar em branco', count: 5
  end

  test 'create and code must be unique' do
    user = login_user
    Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: '22/12/2033', user: user)

    
    visit root_path
    click_on 'Promoções'
    click_on 'Registrar uma promoção'
    fill_in 'Código', with: 'NATAL10'
    click_on 'Criar Promoção'

    assert_text 'já está em uso'
  end

  test 'generate coupons for a promotion' do
    user = login_user
    promotion = Promotion.create!(name: 'Natal',
                                  description: 'Promoção de Natal',
                                  code: 'NATAL10',
                                  discount_rate: 10,
                                  coupon_quantity: 100,
                                  expiration_date: '22/12/2033',
                                  user: user)
    
    promotion.create_promotion_approval(
      user: User.create!(email: 'john.mail@iugu.com.br', password: '123456')
    )
    visit promotion_path(promotion)
    click_on 'Gerar cupons'

    assert_text 'Cupons gerados com sucesso'
    assert_no_link 'Gerar cupons'
    assert_no_text 'NATAL10-0000'
    assert_text 'NATAL10-0001'
    assert_text 'NATAL10-0002'
    assert_text 'NATAL10-0100'
    assert_no_text 'NATAL10-0101'
  end

  test 'edit a promotion' do
    user = login_user
    promotion = Promotion.create!(name: 'Natal',
                                  description: 'Promoção de Natal',
                                  code: 'NATAL10',
                                  discount_rate: 10,
                                  coupon_quantity: 100,
                                  expiration_date: '22/12/2033',
                                  user: user)
    
    visit promotions_path
    within "tr#promotion-#{promotion.code.parameterize}" do
      click_on 'Editar'
    end

    fill_in 'Nome', with: 'Ano Novo'
    fill_in 'Descrição', with: 'Promoção de Ano Novo'
    fill_in 'Código', with: 'VIRADA22'
    fill_in 'Desconto', with: '22'
    fill_in 'Quantidade de cupons', with: '50'
    fill_in 'Data de término', with: '2022-01-31'
    click_on 'Atualizar Promoção'

    visit promotion_path(promotion)
    assert_text 'Ano Novo'
    assert_text 'Promoção de Ano Novo'
    assert_text '22,00%'
    assert_text 'VIRADA22'
    assert_text '31/01/2022'
    assert_text '50'
  end

  test 'edit a promotion with coupons' do
    user = login_user
    promotion = Promotion.create!(name: 'Natal',
                                  description: 'Promoção de Natal',
                                  code: 'NATAL10',
                                  discount_rate: 10,
                                  coupon_quantity: 100,
                                  expiration_date: '22/12/2033',
                                  user: user)
    promotion.create_promotion_approval(
      user: User.create!(email: 'john.mail@iugu.com.br', password: '123456')
    )

    visit promotion_path(promotion)
    click_on 'Gerar cupons'

    visit edit_promotion_path(promotion)

    assert_no_field 'Código'
    assert_no_field 'Desconto'
    assert_no_field 'Quantidade de cupons'
    assert_no_field 'Data de término'
  end

  test 'delete a promotion' do
    user = login_user
    promotion = Promotion.create!(name: 'Natal',
                                  description: 'Promoção de Natal',
                                  code: 'NATAL10',
                                  discount_rate: 10,
                                  coupon_quantity: 100,
                                  expiration_date: '22/12/2033',
                                  user: user)
    
    visit promotions_path
    within "tr#promotion-#{promotion.code.parameterize}" do
      click_on 'Deletar'
    end
    accept_prompt    
    assert_text 'Nenhuma promoção cadastrada'
  end

  test 'search promotion by term and finds results' do
    user = login_user
    christmas = Promotion.create!(name: 'Natal',
                                  description: 'Promoção de Natal',
                                  code: 'NATAL10',
                                  discount_rate: 10,
                                  coupon_quantity: 100,
                                  expiration_date: '22/12/2033',
                                  user: user)
    christmassy = Promotion.create!(name: 'Natalina',
                                    description: 'Promoção de Natal',
                                    code: 'NATAL11',
                                    discount_rate: 10,
                                    coupon_quantity: 100,
                                    expiration_date: '22/12/2033',
                                    user: user)
    cyber_monday = Promotion.create!(name: 'Cyber Monday',
                                    coupon_quantity: 100,
                                    description: 'Promoção de Cyber Monday',
                                    code: 'CYBER15', discount_rate: 15,
                                    expiration_date: '22/12/2033',
                                    user: user)
    visit root_path
    click_on 'Promoções'
    fill_in 'Busca', with: 'natal'
    click_on 'Buscar'

    assert_text christmas.name
    assert_text christmassy.name
    refute_text cyber_monday.name
  end

  test 'search with no results' do
    user = login_user
    christmas = Promotion.create!(name: 'Natal',
                                  description: 'Promoção de Natal',
                                  code: 'NATAL10',
                                  discount_rate: 10,
                                  coupon_quantity: 100,
                                  expiration_date: '22/12/2033',
                                  user: user)
    christmassy = Promotion.create!(name: 'Natalina',
                                    description: 'Promoção de Natal',
                                    code: 'NATAL11',
                                    discount_rate: 10,
                                    coupon_quantity: 100,
                                    expiration_date: '22/12/2033',
                                    user: user)
    visit root_path
    click_on 'Promoções'
    fill_in 'Busca', with: 'cyber'
    click_on 'Buscar'

    assert_text 'Não foram localizadas promoções para esta busca'
    refute_text christmas.name
    refute_text christmassy.name
  end
end
