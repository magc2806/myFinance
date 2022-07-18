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

  scope :search_by_date, ->(min_date,max_date){where(transaction_date: (min_date)..(max_date))}
  scope :search_by_description, ->(description){where("description ILIKE ?", "%#{description}%")}
  scope :search_by_amount, ->(amount){where(amount: amount)}

  def self.search_by_filter bank_account_id, description=nil,amount=nil, min_date=nil, max_date=nil

    transactions = Transaction.where(bank_account_id: bank_account_id)
    return transactions.order(transaction_date: :desc) unless description || amount || min_date || max_date    

    transactions = transactions.search_by_date(min_date,max_date) unless min_date.nil? && max_date.nil?      
    transactions = transactions.search_by_description(description) unless description.nil?               
    transactions = transactions.search_by_amount(amount) unless amount.nil?      
    transactions.order(transaction_date: :desc)    
  end

end