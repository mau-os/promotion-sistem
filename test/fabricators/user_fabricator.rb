Fabricator(:user) do
  email { sequence(:email) { |i| "meu.email#{i}@iugu.com.br" } }
  password '123456'
end
