class CreateTransactions < ActiveRecord::Migration[7.0]
  def change
    create_table :transactions do |t|
      t.decimal :amount, default: 0, precision: 10, scale: 2
      t.date :transation_date, null: false
      t.references :bank_account, null: false, foreign_key: true
      t.string :description, null: false, default: ""

      t.timestamps
    end
  end
end
