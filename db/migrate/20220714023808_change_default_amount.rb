class ChangeDefaultAmount < ActiveRecord::Migration[7.0]
  def change
    change_column_default(:transactions, :amount, 1)
  end
end
