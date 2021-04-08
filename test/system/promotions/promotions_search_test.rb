require 'application_system_test_case'

class PromotionsSearchTest < ApplicationSystemTestCase
  test 'search promotion by term and finds results' do
    login_user
    christmas = Fabricate(:promotion, code: 'NATAL10', name: 'Natal')
    christmassy = Fabricate(:promotion, code: 'NATAL11', name: 'Natalina')
    cyber_monday = Fabricate(:promotion, code: 'CYBER15', name: 'Cyber Monday')
    visit root_path
    click_on 'Promoções'
    fill_in 'Busca', with: 'natal'
    click_on 'Buscar'

    assert_text christmas.name
    assert_text christmassy.name
    refute_text cyber_monday.name
  end

  test 'search with no results' do
    login_user
    christmas = Fabricate(:promotion, code: 'NATAL10', name: 'Natal')
    christmassy = Fabricate(:promotion, code: 'NATAL11', name: 'Natalina')
    visit root_path
    click_on 'Promoções'
    fill_in 'Busca', with: 'cyber'
    click_on 'Buscar'

    assert_text 'Não foram localizadas promoções para esta busca'
    refute_text christmas.name
    refute_text christmassy.name
  end
end
