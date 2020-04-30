require "test_helper"

class CreateCategoriesTest < ActionDispatch::IntegrationTest

  def setup
    @user = User.create(username: "atomic", email: "atomic@example.com", password: "atomic", admin: true)
  end

  test "get new category form and create category" do
    sign_in_as(@user, "atomic")
    get new_category_path
    assert_template "categories/new"
    assert_difference 'Category.count', 1 do
      post categories_path, params:{category:{name:"sports"}}
      follow_redirect!
    end
    assert_template 'categories/index'
    assert_match "sports", response.body
  end

  test "invalid category submission results in failure" do
    sign_in_as(@user, "atomic")
    get new_category_path
    assert_template "categories/new"
    assert_no_difference 'Category.count' do
      post categories_path, params:{category:{name:""}}
    end
    assert_template 'categories/new'
    assert_select "h4.alert-heading"
    assert_select "li"
  end

  test "should redirect create when admin not logged in" do
    assert_no_difference "Category.count" do
      post categories_path, params: {category:{name:"sports"}}
    end
    assert_redirected_to categories_path
  end

end