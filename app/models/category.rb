# == Schema Information
#
# Table name: categories
#
#  id         :bigint           not null, primary key
#  name       :string           default(""), not null
#  color      :string           default("#FFFFFF"), not null
#  active     :boolean          default(TRUE), not null
#  to_analyze :boolean          default(TRUE), not null
#  user_id    :bigint           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Category < ApplicationRecord
  belongs_to :user, inverse_of: :categories
  has_many :transactions, inverse_of: :category, dependent: :destroy

  validates :name, presence: true
  validates :name, uniqueness: {case_sensitive: false, scope: [:active,:user_id] }, if: ->{active?}

  before_update :free_transactions, if: :active_changed?

  def free_transactions
    self.transactions.update_all(category_id: nil) unless self.active     
  end


end

