require "test_helper"

class CategoriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @category = categories(:one)
  end

  test "should get index" do
    get api_v1_categories_url(format: :json)
    assert_response :success
    body = JSON.parse(response.body)
    assert body.is_a?(Array)
  end

  test "should show category" do
    get api_v1_category_url(@category, format: :json)
    assert_response :success
    data = JSON.parse(response.body)
    assert_equal @category.name, data["name"]
  end

  test "should create category" do
    assert_difference("Category.count") do
      post api_v1_categories_url(format: :json), params: { category: { name: "Bills", description: "Monthly" } }
    end
    assert_response :created
    data = JSON.parse(response.body)
    assert_equal "Bills", data["name"]
  end

  test "should not create invalid category" do
    assert_no_difference("Category.count") do
      post api_v1_categories_url(format: :json), params: { category: { description: "no name" } }
    end
    assert_response :unprocessable_entity
  end

  test "should update category" do
    patch api_v1_category_url(@category, format: :json), params: { category: { name: "Groceries2" } }
    assert_response :success
    @category.reload
    assert_equal "Groceries2", @category.name
  end

  test "should destroy category" do
    assert_difference("Category.count", -1) do
      delete api_v1_category_url(@category, format: :json)
    end
    assert_response :no_content
  end
end
