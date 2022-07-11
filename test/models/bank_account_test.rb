# == Schema Information
#
# Table name: bank_accounts
#
#  id             :bigint           not null, primary key
#  owner_id       :bigint           not null
#  name           :string           default("")
#  account_number :string           default(""), not null
#  bank_name      :string           default(""), not null
#  active         :boolean          default(TRUE)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
require "test_helper"

class BankAccountTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  
  test "create bank_account from user" do 
    u = users(:manuel)
    ba = u.bank_accounts.new(name: "principal15", account_number: "0123456", bank_name:"santander")
    ba.save
    assert ba.save
  end

  test "can't create bank_account blank" do 
    u = users(:manuel)
    ba = u.bank_accounts.new(name:"" , account_number: "", bank_name:"")
    assert_not ba.save
    
  end

  test "can't be duplicated account_number within same user and bank_name in active bank_account" do 
    u = users(:manuel)
    ba = u.bank_accounts.new(name:"secundary" , account_number:"123456", bank_name:"scotiabank")
    assert_not ba.save
    
  end

  test "can be duplicated account_number within same user and bank_name in deactivated bank_account" do 
    u = users(:manuel)
    ba = u.bank_accounts.new(name:"cuenta 2" , account_number:"33333", bank_name:"scotiabank")
    
    assert ba.save #debe de poder guardar incluso si hay una cuenta desactivada con la misma combinacion

    assert_not ba.update(account_number: "123456") #no debo poder actualizar el numero a uno usado despues de ya creado
    
    assert ba.update(account_number: "33333")
    assert ba.update(active: false) #solo debo de validar la unicidad si la cuenta está activa

    
  end

  test "can be duplicated account_number in different users" do 
    u = users(:jose)
    ba = u.bank_accounts.new(name:"principal" , account_number:"123456", bank_name:"scotiabank")
    assert ba.save    
  end




  
end
