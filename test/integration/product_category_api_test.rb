require 'test_helper'

class ProductCategoryApiTest < ActionDispatch::IntegrationTest
  test 'show product category' do
    product_category = Fabricate(:product_category)
    get "/api/v1/product_categories/#{product_category.code}", as: :json

    assert_response :success
    body = JSON.parse(response.body, symbolize_names: true)
    assert_equal product_category.code, body[:code]
    assert_equal product_category.name, body[:name]
  end

  test 'create a product category' do
    post '/api/v1/product_categories', as: :json, params: {
      product_category: {
        name: 'Produto Perecivel',
        code: 'PRODPERE',
      }
    }

    assert_response :success
    body = JSON.parse(response.body, symbolize_names: true)
    assert_equal 'PRODPERE', body[:code]
    assert_equal 'Produto Perecivel', body[:name]
  end

  test 'update a product category' do
    product_category = Fabricate(:product_category)
    patch "/api/v1/product_categories/#{product_category.code}",
            as: :json,
            params: {
              code: 'FRAC1',
              name: 'Fracionado'
            }

    assert_response :success
    body = JSON.parse(response.body, symbolize_names: true)
    assert_equal 'FRAC1', body[:code]
    assert_equal 'Fracionado', body[:name]
  end

  test 'destroy a product category' do
    product_category = Fabricate(:product_category)
    delete "/api/v1/product_categories/#{product_category.code}", as: :json

    assert_response :no_content
  end

  test 'do not create product category without all params' do
    post '/api/v1/product_categories', as: :json, params: {
      product_category: {
        name: 'Produto Perecivel'
      }
    }

    assert_response :unprocessable_entity
    body = JSON.parse(response.body, symbolize_names: true)
    assert_includes body[:errors], 'Código não pode ficar em branco'
  end
end