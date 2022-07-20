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

  test "search transactions" do 
    ba = bank_accounts(:bank_account1)
    description = nil
    amount = nil
    min_date = nil
    max_date = nil
    category = nil

    trs = Transaction.search_by_filter(ba.id,category,description, amount, min_date, max_date)
    assert trs.count == 3
    #adding description search
    description = "comida"
    trs = Transaction.search_by_filter(ba.id,category,description, amount, min_date, max_date)
    assert trs.count == 1
    #adding amount search
    description = "pago"
    amount = 1000
    trs = Transaction.search_by_filter(ba.id,category,description, amount, min_date, max_date)
    assert (trs.count == 1 && trs.first.description == "pago arriendo")

    #adding date search
    min_date = Date.new(2022,6,10)
    max_date = Date.new(2022,7,1)
    trs = Transaction.search_by_filter(ba.id,category,nil, nil, min_date, max_date)
    assert (trs.count == 1 && trs.first.description == "pago comida")

    #adding category search
    category = categories(:comida)
    trs = Transaction.search_by_filter(ba.id,category.id,nil,nil,nil,nil)
    assert trs.count == 2

  end

  

end
