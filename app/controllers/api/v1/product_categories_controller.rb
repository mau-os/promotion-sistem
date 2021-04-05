class Api::V1::ProductCategoriesController < Api::V1::ApiController
  def show
    @product_category = ProductCategory.find_by(code: params[:code])
    render json: @product_category
  end

  def create
    product_category_params = params.require(:product_category).permit(:name, :code)
    @product_category = ProductCategory.new(product_category_params)
    if @product_category.save
      render json: @product_category
    else
      render json: { errors: @product_category.errors.full_messages }, status: :unprocessable_entity
    end
  end
end