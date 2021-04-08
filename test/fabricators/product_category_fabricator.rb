Fabricator(:product_category) do
  code { sequence(:code) { |i| "ANTIFRA#{i}"}}
  name "Produto AntiFraude"
end