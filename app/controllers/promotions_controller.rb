class PromotionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_promotion, only: %i[show edit update destroy generate_coupons approve]
  before_action :can_be_approved, only: %i[approve]

  def index
    @promotions = Promotion.all
  end

  def show
  end

  def new
    @promotion = Promotion.new
  end

  def create
    @promotion = current_user.promotions.new(promotion_params)
    if @promotion.save
      redirect_to @promotion
    else
      render :new
    end
  end

  def edit
    @generated_coupons = @promotion.coupons?
  end

  def update
    @promotion.update(promotion_params)
    redirect_to promotions_path
  end

  def destroy
    @promotion.destroy
    redirect_to promotions_path
  end

  def generate_coupons
    @promotion.generate_coupons!
    redirect_to @promotion, notice: t('.success')
  end

  def search
    @promotions = Promotion.search(params[:q])
  end

  def approve
    current_user.promotion_approvals.create!(promotion: @promotion)
    redirect_to @promotion, notice: 'Promoção aprovada com sucesso'
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

    def can_be_approved
      redirect_to @promotion,
      alert: 'Ação não permitida' unless @promotion.can_approve?(current_user)
    end
end