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
require "test_helper"

class CategoryTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end


  test "cant have empty name" do 
    u = users(:manuel)
    cat = u.categories.new

    assert_not cat.save
  end

  test "user cant have active categories with same name" do 
    u = users(:manuel)
    cat = u.categories.new(name: "rent")
    assert_not cat.save
  end
end
