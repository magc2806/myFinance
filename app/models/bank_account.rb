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
end
