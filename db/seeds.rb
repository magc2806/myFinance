# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

#creamos usuario de prueba
u = User.create email: "myfinanceprueba@gmail.com", password: "1234567", language: "español", name: "usuario prueba"

#creamos cuenta de prueba
ba = u.bank_accounts.create(name: "Principal", account_number: "1234567", bank_name: "Santander")
#creamos categorias
category_transaction_hash = {
  "Trabajo" => {bank_account_id: ba.id, amount: 1000000, transaction_date: Date.today, description: "Salario"},
  "Arriendo"=> {bank_account_id: ba.id, amount: 300000, transaction_date: Date.today+1.days, description: "Pago arriendo"},
  "Comida" => {bank_account_id: ba.id, amount: (-20000..-8000), transaction_date: Date.today+rand(10).days, description: "gasto de comida"},
  "Transporte" => {bank_account_id: ba.id, amount: (-8000..-2000), transaction_date: Date.today+rand(10).days, description: "gasto de transporte"},
  "Lujos" => {bank_account_id: ba.id, amount: (-20000..-10000), transaction_date: Date.today+rand(10).days, description: "gasto lujos"}
}

category_transaction_hash.each do |category_name, transaction_data|
  category = u.categories.create(name: category_name, color: '#'.concat(rand(0.."FFFFFF".hex).to_s(16)))

  if ["Trabajo", "Arriendo"].include?(category_name)
    category.transactions.create(transaction_data)
  else
    10.times do |n|
      random_amount = {amount: rand(transaction_data[:amount])}
      category.transactions.create(transaction_data.merge(random_amount))
    end 
  end
end
