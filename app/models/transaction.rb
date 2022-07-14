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
class Transaction < ApplicationRecord
  belongs_to :bank_account

  validates :transaction_date, presence: true
  validates :description, presence: true
  validates :amount, numericality: {other_than: 0}

end
