require 'application_system_test_case'

class Authentication < ApplicationSystemTestCase
  test 'user sign up' do
    visit root_path
    within '#nav-sign-up' do
      click_on 'Cadastrar'
    end
    fill_in 'Email', with: 'meu.email@iugu.com.br'
    fill_in 'Senha', with: 'password'
    fill_in 'Confirmação de senha', with: 'password'
    within 'form' do
      click_on 'Cadastrar'
    end
    
    assert_text 'Boas vindas! Cadastrou e entrou com sucesso'
    assert_text 'meu.email@iugu.com.br'
    assert_link 'Sair'
    assert_no_link 'Cadastrar'
    assert_current_path root_path
  end

  test 'no blank fields in sign in' do
    visit root_path
    within '#nav-sign-up' do
      click_on 'Cadastrar'
    end
    within 'form' do
      click_on 'Cadastrar'
    end
    
    assert_text 'Senha não pode ficar em branco'
    assert_text 'Email não pode ficar em branco'
  end

  test 'user sign in' do
    user = User.create!(email: 'meu.email@iugu.com.br', password: 'password')

    visit root_path
    click_on 'Entrar'
    fill_in 'Email', with: user.email
    fill_in 'Senha', with: user.password
    click_on 'Continuar'

    assert_text 'Login efetuado com sucesso!'
    assert_text user.email
    assert_current_path root_path
    assert_link 'Sair'
    assert_no_link 'Entrar'
  end

  test 'user sign out' do
    login_user

    visit root_path    
    click_on 'Sair'

    assert_current_path new_user_session_path
    assert_no_text 'meu.email@iugu.com.br'
    assert_link 'Entrar'
    assert_no_link 'Sair'
  end

  test 'user edit password' do
    user = User.create!(email: 'meu.email@iugu.com.br', password: 'password')
    token = user.send(:set_reset_password_token)


    visit edit_user_password_path(user, reset_password_token: token)

    fill_in 'Nova senha', with: '654321'
    fill_in 'Confirmação de nova senha', with: '654321'
    click_on 'Trocar minha senha'

    assert_text 'Sua senha foi alterada com sucesso'
    assert_current_path root_path
  end
end
