require "test_helper"

class PromotionTest < ActiveSupport::TestCase
  def setup
    @user = User.create!(email: 'meu.email@iugu.com.br', password: '123456')
  end

  test 'attributes cannot be blank' do
    promotion = Promotion.new

    refute promotion.valid?
    assert_includes promotion.errors[:name], 'não pode ficar em branco'
    assert_includes promotion.errors[:code], 'não pode ficar em branco'
    assert_includes promotion.errors[:discount_rate], 'não pode ficar em '\
                                                      'branco'
    assert_includes promotion.errors[:coupon_quantity], 'não pode ficar em'\
                                                        ' branco'
    assert_includes promotion.errors[:expiration_date], 'não pode ficar em'\
                                                        ' branco'
  end

  test 'code must be uniq' do
    promotion = Fabricate(:promotion)
    new_promotion = Promotion.new(code: promotion.code)

    refute new_promotion.valid?
    assert_includes new_promotion.errors[:code], 'já está em uso'
  end

  test 'name must be uniq' do
    promotion = Fabricate(:promotion)
    new_promotion = Promotion.new(name: promotion.name)

    refute new_promotion.valid?
    assert_includes new_promotion.errors[:name], 'já está em uso'
  end

  test 'generate_coupons! succesfully' do
    promotion = Fabricate(:promotion, code: 'NATAL10')

      promotion.generate_coupons!
      assert_equal promotion.coupons.size, promotion.coupon_quantity
      assert_equal promotion.coupons.first.code, 'NATAL10-0001'
  end

  test 'generate_coupons! cannot be called twice' do
    promotion = Fabricate(:promotion)

    Coupon.create!(code:'BLABLABLA', promotion: promotion)

    promotion.generate_coupons!
    assert_no_difference 'Coupon.count' do
      promotion.generate_coupons!
    end
  end

  test '.search by exact' do
    christmas = Fabricate(:promotion, code: 'NATAL10', name: 'Natal')
    cyber_monday = Fabricate(:promotion, code: 'CYBER15', name: 'Cyber Monday')


    result = Promotion.search('Natal')
    assert_includes result, christmas
    refute_includes result, cyber_monday
  end

  test '.search by partial' do
    christmas = Fabricate(:promotion, code: 'NATAL10', name: 'Natal')
    christmassy = Fabricate(:promotion, code: 'NATAL11', name: 'Natalina')
    cyber_monday = Fabricate(:promotion, code: 'CYBER15', name: 'Cyber Monday')

    result = Promotion.search('Natal')
    assert_includes result, christmas
    assert_includes result, christmassy
    refute_includes result, cyber_monday
  end

  test '.search finds nothing' do
    christmas = Fabricate(:promotion, code: 'NATAL10', name: 'Natal')
    cyber_monday = Fabricate(:promotion, code: 'CYBER15', name: 'Cyber Monday')


    result = Promotion.search('carnaval')
    assert_empty result
  end

end
