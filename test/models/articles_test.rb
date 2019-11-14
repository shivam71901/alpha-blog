require 'test_helper'

class ArticlesTest < ActiveSupport::TestCase

  def setup
    @user = User.create!(username: "yash", email: "yash@example.com",
                         password: "password")
    @article = @user.articles.create(title: "hola guys", description: "How are you friends")
  end

  test "article without user should be invalid" do
    @article.user_id = nil
    assert_not @article.valid?
  end

  test "article should be valid" do
    assert @article.valid?
  end

  test "name should be present" do
    @article.title = ""
    assert_not @article.valid?
  end

  test "description should be present" do
    @article.description = ""
    assert_not @article.valid?
  end

  test "description should not be less then 10 characters" do
    @article.description = "a" * 3
    assert_not @article.valid?
  end

  test "description should not be greater than 500 characters" do
    @article.description = "a" * 501
    assert_not @article.valid?
  end
end
