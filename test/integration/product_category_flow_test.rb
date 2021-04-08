require 'test_helper'

class ProductCategoryFlowTest < ActionDispatch::IntegrationTest
  test 'cannot create a product category without login' do
    post product_categories_path, params: {
      product_category: {
        name: 'Produto AntiFraude',
        code: 'ANTIFRA'
      }
    }

    assert_redirected_to new_user_session_path
  end

  test 'cannot edit a product category without login' do
    product_category = Fabricate(:product_category)

    patch product_category_path(product_category), params: {
      product_category: {
        name: 'Produto AntiFraude Alterado',
        code: 'ANTIFRA'
      }
    }

    assert_redirected_to new_user_session_path
  end

  test 'cannot delete a product category without login' do
    product_category = Fabricate(:product_category)

    delete product_category_path(product_category)

    assert_redirected_to new_user_session_path
  end
end
