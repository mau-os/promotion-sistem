require 'application_system_test_case'

class ProductCategoriesTest < ApplicationSystemTestCase
  test 'view product categories' do
    ProductCategory.create!(name: 'Eletrônico', code: 'ELECTRO')
    ProductCategory.create!(name: 'Produto AntiFraude', code: 'ANTIFRA')

    visit root_path
    click_on 'Categorias de Produtos'

    assert_text 'Eletrônico'
    assert_text 'ELECTRO'
    assert_text 'Produto AntiFraude'
    assert_text 'ANTIFRA'
  end

  test 'view product category details' do
    ProductCategory.create!(name: 'Eletrônico', code: 'ELECTRO')
    ProductCategory.create!(name: 'Produto AntiFraude', code: 'ANTIFRA')

    visit product_categories_path
    click_on 'Produto AntiFraude'

    assert_text 'Produto AntiFraude'
    assert_text 'ANTIFRA'
  end

  test 'no product category are available' do
    visit root_path
    click_on 'Categorias de Produtos'

    assert_text 'Nenhuma categoria de produto cadastrada'
  end

  test 'view product categories and return to home page' do
    ProductCategory.create!(name: 'Eletrônico', code: 'ELECTRO')

    visit root_path
    click_on 'Categorias de Produtos'
    click_on 'Voltar'

    assert_current_path root_path
  end

  test 'view details and return to product categories page' do
    ProductCategory.create!(name: 'Eletrônico', code: 'ELECTRO')

    visit root_path
    click_on 'Categorias de Produtos'
    click_on 'Eletrônico'
    click_on 'Voltar'

    assert_current_path product_categories_path
  end

  test 'create a product category' do
    visit root_path
    click_on 'Categorias de Produtos'
    click_on 'Registrar uma categoria de produto'
    fill_in 'Nome', with: 'Produto AntiFraude'
    fill_in 'Código', with: 'ANTIFRA'
    click_on 'Criar Categoria de Produto'

    assert_current_path product_category_path(ProductCategory.last)
    assert_text 'Produto AntiFraude'
    assert_text 'ANTIFRA'
    assert_link 'Voltar'
  end

  test 'create and attributes cannot be blank' do
    visit root_path
    click_on 'Categorias de Produtos'
    click_on 'Registrar uma categoria de produto'
    click_on 'Criar Categoria de Produto'

    assert_text 'não pode ficar em branco', count: 2
  end

  test 'create and code must be unique' do
    ProductCategory.create!(name: 'Eletrônico', code: 'ELECTRO')

    visit root_path
    click_on 'Categorias de Produtos'
    click_on 'Registrar uma categoria de produto'
    fill_in 'Código', with: 'ELECTRO'
    click_on 'Criar Categoria de Produto'

    assert_text 'já está em uso'
  end

  test 'edit a product category' do
    product_category = ProductCategory.create!(name: 'Eletrônico', code: 'ELECTRO')

    visit product_categories_path
    click_on 'Editar'

    fill_in 'Nome', with: 'Produto AntiFraude'
    fill_in 'Código', with: 'ANTIFRA'
    click_on 'Atualizar Categoria de Produto'

    visit product_category_path(product_category)
    assert_text 'Produto AntiFraude'
    assert_text 'ANTIFRA'
  end

  test 'delete a product category' do
    ProductCategory.create!(name: 'Eletrônico', code: 'ELECTRO')

    visit product_categories_path
    click_on 'Deletar'
    accept_prompt    
    assert_text 'Nenhuma categoria de produto cadastrada'
  end
end