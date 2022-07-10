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
    ba = u.bank_accounts.new(name: "principal", account_number: "123456", bank_name:"santander")
    ba.save
    assert ba.save
  end

  
end
