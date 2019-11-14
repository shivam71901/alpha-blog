require 'test_helper'

class ArticleTest < ActionDispatch::IntegrationTest

  def setup
    @user = User.create!(username: "yash", email: "yash@example.com",
                        password: "password")
    @article = Article.create(title: "hello guys", description: "how are you fellas", user: @user)
    @article2 = @user.articles.build(title: "hey everyone", description: "el classico date confirmed 18 dec")
    @article2.save
  end

  test "should get articles index" do
    get articles_url
    assert_response :success
  end

  test "should get articles listing" do
    get articles_path
    assert_template 'articles/index'
    assert_select "a[href=?]", article_path(@article), text: @article.title
    assert_select "a[href=?]", article_path(@article2), text: @article2.title
  end

  test "should get articles show" do
    sign_in_as(@user, "password")
    get article_path(@article)
    assert_template 'articles/show'
    #assert_match @recipe.name, response.body
    assert_match @article.description, response.body
    assert_match @user.username, response.body
    assert_select "a[href=?]", edit_article_path(@article), text: "Edit this article"
    assert_select "a[href=?]", article_path(@article), text: "Delete this article"
    assert_select "a[href=?]", articles_path, text: "Articles"
  end

  test "create new vaild article" do
    sign_in_as(@user, "password")
    get new_article_path
    assert_template 'articles/new'
    title_of_article = "heyy there"
    description_of_article = "whats going on mates??"

    assert_difference 'Article.count', 1 do
      post articles_path, params: { article: { title: title_of_article, description: description_of_article}}
    end
    follow_redirect!
    assert_match title_of_article, response.body
    assert_match description_of_article, response.body
  end

  test "reject invalid article" do
    sign_in_as(@user, "password")
    get new_article_path
    assert_template 'articles/new'
    assert_no_difference 'Article.count' do
      post articles_path, params: { article: { title: " ", description: " "}}
    end
    assert_template 'articles/new'
    assert_select 'h2.panel-title'
    assert_select 'div.panel-body'
  end
end
