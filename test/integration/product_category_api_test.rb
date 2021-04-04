require 'test_helper'

class ProductCategoryApiTest < ActionDispatch::IntegrationTest
  test 'show product category' do
    product_category = ProductCategory.create!(name: 'Produto AntiFraude',
                                               code: 'ANTIFRA')

    get "/api/v1/product_categories/#{product_category.code}"

    assert_response :success
    body = JSON.parse(response.body, symbolize_names: true)
    assert_equal product_category.code, body[:code]
    assert_equal product_category.name, body[:name]
  end

  test 'create a product category' do
    post "/api/v1/product_categories", params: {
      product_category: {
        name: 'Produto AntiFraude',
        code: 'ANTIFRA',
      }
    }

    assert_response :success
    body = JSON.parse(response.body, symbolize_names: true)
    assert_equal 'ANTIFRA', body[:code]
    assert_equal 'Produto AntiFraude', body[:name]
  end
end