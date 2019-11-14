require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def setup
    @user = User.new(username: "yash", email: "yash@example.com", password: "password")
  end

  test "user should be valid" do
    assert @user.valid?
  end

  test "user should have a name" do
    @user.username = ""
    assert_not @user.valid?
  end

  test "name should be less than 30 charatures" do
    @user.username = "a" * 31
    assert_not @user.valid?
  end

  test "name should be greater than two charatures" do
    @user.username = "a"
    assert_not @user.valid?
  end

  test "email should be present" do
    @user.email = ""
    assert_not @user.valid?
  end

  test "email should be valid format" do
    valid_emails = %w[yash@exmple.com tyagi@gmail.com john@yahoo.ca bill.smith@co.uk.org]
    valid_emails.each do |valids|
      @user.email = valids
      assert @user.valid?, "#{valids.inspect} should be valid"
    end
  end

  test "should reject invalid email formats" do
    invalid_emails = %w[user@exmple greggmail.com john@yahoo,ca bill.smith_at_co.uk.org]
    invalid_emails.each do |invalids|
      @user.email = invalids
      assert_not @user.valid?, "#{invalids.inspect} should be regected"
    end
  end

  test "email should be unique" do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end

  test "emails should be saved as lowercase" do
    mixed_email = "JohN@Example.Com"
    @user.email = mixed_email
    @user.save
    assert_equal mixed_email.downcase, @user.reload.email
  end

  test "password should be present" do
    @user.password = ""
    assert @user.valid?
  end

  test "password should be atleast 5 character" do
    @user.password = "x" * 4
    assert @user.valid?
  end

  test "associated articles should be destroyed" do
    @user.save
    @user.articles.create!(title: "testing destroy", description: "testing destroy function")
    assert_difference 'Article.count', -1 do
      @user.destroy
    end
  end

end
