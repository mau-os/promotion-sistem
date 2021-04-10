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
end
