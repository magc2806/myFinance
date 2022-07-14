# == Schema Information
#
# Table name: transactions
#
#  id               :bigint           not null, primary key
#  amount           :decimal(10, 2)   default(0.0)
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
end
