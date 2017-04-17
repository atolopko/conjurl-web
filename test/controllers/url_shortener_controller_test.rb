require 'test_helper'

class UrlShortenerControllerTest < ActionDispatch::IntegrationTest
  test "should get shorten" do
    get url_shortener_shorten_url
    assert_response :success
  end

end
