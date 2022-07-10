class CreateBankAccounts < ActiveRecord::Migration[7.0]
  def change
    create_table :bank_accounts do |t|
      t.references :owner, null: false, foreign_key: {to_table: :users}, index: true
      t.string :name, default: ""
      t.string :account_number, null: false, default: ""
      t.string :bank_name, null: false, default: ""
      t.boolean :active, default: true

      t.timestamps
    end
  end
end
