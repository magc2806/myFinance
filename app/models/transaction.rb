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

  def self.search_by_filter(bank_account_id, category_id=nil, description=nil,amount=nil, min_date=nil, max_date=nil)

    transactions = Transaction.where(bank_account_id: bank_account_id)
    return transactions.order(transaction_date: :desc) unless category_id || description || amount || min_date || max_date    
    
    transactions = transactions.search_by_category(category_id) unless category_id.nil?
    transactions = transactions.search_by_date(min_date,max_date) unless min_date.nil? && max_date.nil?      
    transactions = transactions.search_by_description(description) unless description.nil?               
    transactions = transactions.search_by_amount(amount) unless amount.nil?      
    transactions.order(transaction_date: :desc)    
  end

  def self.dates_checking(min_date, max_date)
    (min_date && max_date).present? || min_date.nil? &&  max_date.nil?   
  end

  def self.generate_excel_report(transactions)
    excel_file = Axlsx::Package.new
    workbook = excel_file.workbook
    excel_sheets_data = generate_excel_sheets(transactions)
    excel_sheets_data.each do |sheet_data|
      workbook.add_worksheet(name: sheet_data[:worksheet_name]) do |sheet|
        sheet.add_row sheet_data[:headers] unless sheet_data[:headers].empty? 
        sheet_data[:content].each do |row|
          sheet.add_row row
        end
      end
    end    
    excel_file
  end

  def self.generate_excel_sheets(transactions)
    [all_transactions_sheet(transactions)] + [transactions_by_category_sheet(transactions)]
  end

  def self.all_transactions_sheet(transactions)
    data_hash={}
    data_hash[:worksheet_name] = I18n.t('reports.transaction.all')
    data_hash[:headers] = [
      I18n.t('activerecord.attributes.transaction.transaction_date').titleize,
      I18n.t('activerecord.models.category.one').titleize,
      I18n.t('activerecord.attributes.transaction.description').titleize,
      I18n.t('activerecord.attributes.transaction.amount').titleize,
    ]
    data_hash[:content] = transactions.map{|transaction| 
      [ 
        transaction.transaction_date, 
        transaction.category&.name,
        transaction.description,
        transaction.amount
      ]
    }
    data_hash
  end

  def self.transactions_by_category_sheet transactions
    grouped_transactions = transactions.group_by{|transaction| transaction.category&.name}
    data_hash={}
    data_hash[:worksheet_name] = I18n.t('reports.transaction.by_category')    
    data_hash[:headers] = ''
    data_hash[:content] = [] 
    grouped_transactions.each do |category, transactions|
      category||= I18n.t('views.category.no_category').titleize
      data_hash[:content] << [category]
      transactions.each do |transaction|
        data_hash[:content] << [transaction.transaction_date,transaction.description,transaction.amount]
      end          
    end
    data_hash
  end
end
