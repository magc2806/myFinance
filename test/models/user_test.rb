# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  name                   :string           default(""), not null
#  language               :string           default("español"), not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
require "test_helper"

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test "user name is required" do
    user = User.new(email: "email3@email.com", password: "123456" ) 
    assert_not user.valid?
  end

  test "email can't be duplacated" do
    user = User.new(name: "pedro", email: "manuel@gmail.com",password: "123456")
    assert_not user.save
  end

  test "email can't invalid format" do
    user = User.new(name: "pedro", email: "manuel@",password: "123456")
    
    assert_not user.save
  end
end
