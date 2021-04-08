class Api::V1::ProductCategoriesController < Api::V1::ApiController
  before_action :set_product_category, only: %i[show update destroy]
  before_action :product_category_params, only: %i[create update]

  def show; end

  def create
    @product_category = ProductCategory.create!(product_category_params)
  end

  def update
    @product_category.update(product_category_params)
  end

  def destroy
    @product_category.destroy!
  end

  private

  def set_product_category
    @product_category = ProductCategory.find_by(code: params[:code])
  end

  def product_category_params
    params.require(:product_category).permit(:name, :code)
  end
end
