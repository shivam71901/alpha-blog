require 'test_helper'

class UserIndexTest < ActionDispatch::IntegrationTest
  def setup
    @user = User.create!(username: "yash", email: "yash@example.com",
                    password: "password")
    @user2 = User.create!(username: "tyagi", email: "tyagi@example.com",
                    password: "password")
    @admin_user = User.create!(username: "shivam", email: "shivam@example.com",
                    password: "password", admin: true)
  end

  test "should get chefs listing" do
    get users_path
    assert_template 'users/index'
  assert_select "a[href=?]", user_path(@user), text: @user.username
  assert_select "a[href=?]", user_path(@user2), text: @user2.username
  assert_select "a[href=?]", user_path(@admin_user), text: @admin_user.username
  end
end
