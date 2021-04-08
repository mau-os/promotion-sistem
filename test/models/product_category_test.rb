require 'test_helper'

class ProductCategoryTest < ActiveSupport::TestCase
  test 'attributes cannot be blank' do
    product_category = ProductCategory.new

    assert_not product_category.valid?
    assert_includes product_category.errors[:name], 'não pode ficar em branco'
    assert_includes product_category.errors[:code], 'não pode ficar em branco'
  end

  test 'code must be uniq' do
    product_category = Fabricate(:product_category)
    new_product_category = ProductCategory.new(code: product_category.code)

    assert_not new_product_category.valid?
    assert_includes new_product_category.errors[:code], 'já está em uso'
  end
end
