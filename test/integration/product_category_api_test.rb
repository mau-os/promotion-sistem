require 'test_helper'

class ProductCategoryApiTest < ActionDispatch::IntegrationTest
  test 'show product category' do
    product_category = ProductCategory.create!(name: 'Produto AntiFraude',
                                               code: 'ANTIFRA')

    get "/api/v1/product_categories/#{product_category.code}"

    assert_response :success
    body = JSON.parse(response.body, symbolize_names: true)
    assert_equal body[:code], product_category.code
    assert_equal body[:name], product_category.name
  end

  test 'create a product category' do
    post '/api/v1/product_categories', params: {
      product_category: {
        name: 'Produto AntiFraude',
        code: 'ANTIFRA',
      }
    }

    assert_response :success
    body = JSON.parse(response.body, symbolize_names: true)
    assert_equal body[:code], 'ANTIFRA'
    assert_equal body[:name], 'Produto AntiFraude'
  end

  test 'do not create product category without all params' do
    post '/api/v1/product_categories', params: {
      product_category: {
        name: 'Produto AntiFraude'
      }
    }

    assert_response :unprocessable_entity
    body = JSON.parse(response.body, symbolize_names: true)
    assert_includes body[:errors], 'Código não pode ficar em branco'
  end
end