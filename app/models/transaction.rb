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
  belongs_to :category, optional: true, inverse_of: :transactions

  validates :transaction_date, presence: true
  validates :description, presence: true
  validates :amount, numericality: {other_than: 0}

  scope :search_by_date, ->(min_date,max_date){where(transaction_date: (min_date)..(max_date))}
  scope :search_by_description, ->(description){where("description ILIKE ?", "%#{description}%")}
  scope :search_by_amount, ->(amount){where(amount: amount)}
  scope :search_by_category, ->(category_id){where(category_id: category_id)}
  def self.search_by_filter bank_account_id, category_id=nil, description=nil,amount=nil, min_date=nil, max_date=nil

    transactions = Transaction.where(bank_account_id: bank_account_id)
    return transactions.order(transaction_date: :desc) unless category_id || description || amount || min_date || max_date    
    
    transactions = transactions.search_by_category(category_id) unless category_id.nil?
    transactions = transactions.search_by_date(min_date,max_date) unless min_date.nil? && max_date.nil?      
    transactions = transactions.search_by_description(description) unless description.nil?               
    transactions = transactions.search_by_amount(amount) unless amount.nil?      
    transactions.order(transaction_date: :desc)    
  end

  def self.dates_checking min_date, max_date
    (min_date && max_date).present? || min_date.nil? &&  max_date.nil?   
  end

end
