require 'application_system_test_case'

class PromotionsProductCategoriesTest < ApplicationSystemTestCase
  test 'select a product category for a promotion' do
    promotion = Fabricate(:promotion)
    ProductCategory.create!(name: 'Produto AntiFraude', code: 'ANTIFRA')
    ProductCategory.create!(name: 'Produto Perecivel', code: 'ANTIPERECI')
    login_user

    visit edit_promotion_path(promotion)

    check('Produto AntiFraude')
    click_on 'Atualizar Promoção'

    visit promotion_path(promotion)

    assert_text 'Produto AntiFraude'
    refute_text 'Produto Perecivel'
  end

  test 'edit product categories of a promotions' do
    promotion = Fabricate(:promotion)
    selected_product_category = ProductCategory.create!(name: 'Produto AntiFraude', code: 'ANTIFRA')
    ProductCategory.create!(name: 'Produto Perecivel', code: 'ANTIPERECI')
    PromotionProductCategory.create!(promotion: promotion, product_category: selected_product_category)
    login_user

    visit edit_promotion_path(promotion)

    assert_checked_field 'Produto AntiFraude'
    assert_unchecked_field 'Produto Perecivel'
  end

  test 'create a promotion with product categories' do
    ProductCategory.create!(name: 'Produto AntiFraude', code: 'ANTIFRA')
    ProductCategory.create!(name: 'Produto Perecivel', code: 'ANTIPERECI')
    login_user

    visit new_promotion_path
    fill_in 'Nome', with: 'Cyber Monday'
    fill_in 'Descrição', with: 'Promoção de Cyber Monday'
    fill_in 'Código', with: 'CYBER15'
    fill_in 'Desconto', with: '15'
    fill_in 'Quantidade de cupons', with: '90'
    fill_in 'Data de término', with: '2033-12-22'
    check('Produto AntiFraude')

    click_on 'Criar Promoção'

    assert_current_path promotion_path(Promotion.last)
    assert_text 'Cyber Monday'
    assert_text 'Promoção de Cyber Monday'
    assert_text '15,00%'
    assert_text 'CYBER15'
    assert_text '22/12/2033'
    assert_text '90'
    assert_text 'Produto AntiFraude'
    refute_text 'Produto Perecivel'
  end
end
