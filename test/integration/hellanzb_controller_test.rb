require File.join(File.dirname(__FILE__), '..', 'test_helper')

class HellanzbControllerTest < ActionController::TestCase
  test "index page should try to start the server and should render the server_down action" do
    Hellanzb.expects(:client).once.raises(Hellanzb::ServerDown)
    get :index
    assert_response :success, @response.body
    assert_template "server_down"
  end
end
