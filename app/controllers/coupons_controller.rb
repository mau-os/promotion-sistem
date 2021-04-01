class CouponsController < ApplicationController
  def disable
    @coupon = Coupon.find(params[:id])
    @coupon.disabled!
    redirect_to @coupon.promotion, notice: t('.success', code: @coupon.code)
  end

  def activate
    @coupon = Coupon.find(params[:id])
    @coupon.active!
    redirect_to @coupon.promotion, notice: 'Cupom NATAL10-0001 ativado com sucesso'
  end

  def search
    @coupon = Coupon.find_by(code: params[:code])
    redirect_back fallback_location: :fallback_location, notice: 'Cupom não encontrado' unless @coupon.present?
  end
end