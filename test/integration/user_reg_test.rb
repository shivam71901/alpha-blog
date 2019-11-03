require 'test_helper'

class UserRegTest < ActionDispatch::IntegrationTest

  test "Register New User" do
    get signup_path
    assert_template 'users/new'
    assert_difference 'User.count', 1 do
      post users_path, params: {user:{username:"yash", email:"yash@gmail.com", password:"password"}}
      follow_redirect!
    end
    assert_template 'users/show'
    assert_match "yash", response.body
  end

end
