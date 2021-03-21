class PromotionsController < ApplicationController
  def index
    @promotions = Promotion.all
  end

  def show
    set_promotion
  end

  def new
    @promotion = Promotion.new
  end

  def create
    @promotion = Promotion.new(promotion_params)
    if @promotion.save
      redirect_to @promotion
    else
      render :new
    end
  end

  def edit
    set_promotion
    @generated_coupons = @promotion.coupons.any?
  end

  def update
    set_promotion
    @promotion.update(promotion_params)
    redirect_to root_path
  end

  def destroy
    set_promotion
    @promotion.destroy
    redirect_to promotions_path
  end

  def generate_coupons
    set_promotion

    (1..@promotion.coupon_quantity).each do |number|
      Coupon.create!(code: "#{@promotion.code}-#{'%04d' % number}", promotion: @promotion)
    end

    flash[:notice] = 'Cupons gerados com sucesso'

    redirect_to @promotion
  end

  private

    def set_promotion
      @promotion = Promotion.find(params[:id])
    end

    def promotion_params
      params
        .require(:promotion)
        .permit(:name, :description, :expiration_date,
              :code, :discount_rate, :coupon_quantity)
    end

end