# == Schema Information
#
# Table name: bank_accounts
#
#  id             :bigint           not null, primary key
#  owner_id       :bigint           not null
#  name           :string           default("")
#  account_number :string           default(""), not null
#  bank_name      :string           default(""), not null
#  active         :boolean          default(TRUE)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
class BankAccount < ApplicationRecord
  belongs_to :owner, class_name: 'User',foreign_key: :owner_id

  has_many :transactions, dependent: :destroy

  validates :bank_name, presence: true
  validates :account_number, presence: true
  validates :name, presence: true
  validates :account_number, uniqueness: { scope: [:active,:owner_id, :bank_name] }, if: ->{active?}

end
