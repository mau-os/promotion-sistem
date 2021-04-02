class CouponsController < ApplicationController
  before_action :set_coupon, only: %i[show disable activate]
  before_action :search_by_code, only: %i[search]

  def show
  end

  def disable
    @coupon.disabled!
    redirect_to @coupon.promotion, notice: t('.success', code: @coupon.code)
  end

  def activate
    @coupon.active!
    redirect_to @coupon.promotion, notice: 'Cupom NATAL10-0001 ativado com sucesso'
  end

  def search
    redirect_to @coupon
  end

  private

    def set_coupon
      @coupon = Coupon.find(params[:id])
    end

    def search_by_code
      @coupon = Coupon.find_by(code: params[:code])
      redirect_back fallback_location: :fallback_location, notice: 'Cupom não encontrado' unless @coupon
    end
end