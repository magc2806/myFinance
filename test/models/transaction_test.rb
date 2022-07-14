# == Schema Information
#
# Table name: transactions
#
#  id               :bigint           not null, primary key
#  amount           :decimal(10, 2)   default(1.0)
#  transaction_date :date             not null
#  bank_account_id  :bigint           not null
#  description      :string           default(""), not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
require "test_helper"

class TransactionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test "not empty transaction" do 
    tr = bank_accounts(:bank_account1).transactions.new
    assert_not tr.save
  end

  test "cant have 0 as amount" do 
    tr = bank_accounts(:bank_account1).transactions.new(amount: 0, transaction_date: Date.today, description: "test")
    assert_not tr.save
  end

  

end
