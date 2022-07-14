class RenameColumnTransationToTransactionDate < ActiveRecord::Migration[7.0]
  def change
    rename_column :transactions, :transation_date, :transaction_date
  end
end
