require 'test_helper'

class ArticlesEditTest < ActionDispatch::IntegrationTest

  def setup
    @user = User.create!(username: "yash", email: "yash@example.com",
                          password: "password")
    @user2 = User.create!(username: "tyagi", email: "tyagi@example.com",
                        password: "password")
    @article = Article.create(title: "Hola guys", description: "This is a test article!!", user: @user)
  end

  test "reject invalid article update" do
    sign_in_as(@user, "password")
    get edit_article_path(@article)
    assert_template 'articles/edit'
    patch article_path(@article), params: { article: { title: " ", description: " "}}
    assert_template 'articles/edit'
    assert_select 'h2.panel-title'
    assert_select 'div.panel-body'

  end

  test "successfuly edit article update" do
    sign_in_as(@user, "password")
    get edit_article_path(@article)
    assert_template 'articles/edit'
    updated_title = "Updated article title"
    updated_description = "Updated article description"
    patch article_path(@article), params: { article: { title: updated_title, description: updated_description}}
    assert_redirected_to @article
    assert_not flash.empty?
    @article.reload
    assert_match updated_title, @article.title
    assert_match updated_description, @article.description
  end

end
