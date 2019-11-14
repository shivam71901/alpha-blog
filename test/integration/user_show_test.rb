require 'test_helper'

class UserShowTest < ActionDispatch::IntegrationTest

  def setup
    @user = User.create!(username: "yash",
                        email: "yash@example.com",
                        password: "password",
                        )
    @article = Article.create(title: "hey guys",
        description: "This is a test article description",
        user: @user)
    @article2 = @user.articles.build(title: "hola everyone",
                          description: "muchas gracias everyone")
    @article2.save
  end

  test "should get users show" do
    get user_path(@user)
    assert_template 'users/show'
    assert_select "a[href=?]", article_path(@article), text: @article.title
    assert_select "a[href=?]", article_path(@article2), text: @article2.title
    assert_match @article.description, response.body
    assert_match @article2.description, response.body
    assert_match @user.username, response.body
  end


end
