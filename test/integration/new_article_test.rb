require 'test_helper'

class NewArticle < ActionDispatch::IntegrationTest

  def setup
    @user = User.create(username: "yash", email:"yash@gmail.com", password: "password", admin: true)
  end

  test "create a new article" do
    sign_in_as(@user,"password")
    get new_article_path
    assert_template 'articles/new'
    assert_difference 'Article.count', 1 do
      post articles_path, params:{article:{title:"This is a test post", description:"This is the info on the body."}}
      follow_redirect!
    end
    assert_template 'articles/show'
    assert_match "test post", response.body
  end
end
