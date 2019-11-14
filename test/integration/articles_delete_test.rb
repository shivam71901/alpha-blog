require 'test_helper'

class ArticlesDeleteTest < ActionDispatch::IntegrationTest

  def setup
    @user = User.create!(username: "yash", email: "yash@example.com",
                        password: "password")
    @article = Article.create(title: "wassup everyone", description: "how are you my friends", user: @user)
  end

  test "Successfully delete a article" do
    sign_in_as(@user, "password")
    get article_path(@article)
    assert_template 'articles/show'
    assert_select "a[href=?]", article_path(@article), text: "Delete this article"
    assert_difference 'Article.count', -1 do
      delete article_path(@article)
    end
    assert_redirected_to articles_path
    assert_not flash.empty?
  end
end
