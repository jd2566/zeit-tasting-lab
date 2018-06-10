require 'test_helper'

class RootCategoriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @root_category = root_categories(:one)
  end

  test "should get index" do
    get root_categories_url, as: :json
    assert_response :success
  end

  test "should create root_category" do
    assert_difference('RootCategory.count') do
      post root_categories_url, params: { root_category: {  } }, as: :json
    end

    assert_response 201
  end

  test "should show root_category" do
    get root_category_url(@root_category), as: :json
    assert_response :success
  end

  test "should update root_category" do
    patch root_category_url(@root_category), params: { root_category: {  } }, as: :json
    assert_response 200
  end

  test "should destroy root_category" do
    assert_difference('RootCategory.count', -1) do
      delete root_category_url(@root_category), as: :json
    end

    assert_response 204
  end
end
