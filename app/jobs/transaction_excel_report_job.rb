class TransactionExcelReportJob < ApplicationJob
  queue_as :default

  def perform(bank_account_id,category_id,description, amount, min_date, max_date)

  end
end
