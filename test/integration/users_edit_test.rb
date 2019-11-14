require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  def setup
    @user = User.create!(username: "yash", email: "yash@example.com",
                          password: "password")
    @user2 = User.create!(username: "tyagi", email: "tyagi@example.com",
                        password: "password")
    @admin_user = User.create!(username: "shivam", email: "shivam@example.com",
                        password: "password", admin: true)
  end

  test "reject an invalid edit" do
    sign_in_as(@user, "password")
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), params: { user: { username: " ", email: "yash@example.com" } }
    assert_template 'users/edit'
    assert_select 'h2.panel-title'
    assert_select 'div.panel-body'
  end

  test "accept valid edit" do
    sign_in_as(@user, "password")
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), params: { user: { username: "yash1", email: "yash1@example.com" } }

    assert_not flash.empty?
    @user.reload
    assert_match "yash1", @user.username
    assert_match "yash1@example.com", @user.email
  end

  test "accept edit attempt by admin user" do
    sign_in_as(@admin_user, "password")
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), params: { user: { username: "yash3", email: "yash3@example.com" } }

    assert_not flash.empty?
    @user.reload
    assert_match "yash3", @user.username
    assert_match "yash3@example.com", @user.email
  end

  test "redirect edit attempt by another non-admin user" do
    sign_in_as(@user2, "password")
    updated_username = "joe"
    updated_email = "joe@example.com"
    patch user_path(@user), params: { user: { username: updated_username, email: updated_email } }
    
    assert_not flash.empty?
    @user.reload
    assert_match "yash", @user.username
    assert_match "yash@example.com", @user.email
  end
end
