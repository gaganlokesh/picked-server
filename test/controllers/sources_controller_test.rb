require "test_helper"

class SourcesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get sources_index_url
    assert_response :success
  end
end
