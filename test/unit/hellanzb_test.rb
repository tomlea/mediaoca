require File.join(File.dirname(__FILE__), '..', 'test_helper')

class HellanzbTest < ActiveSupport::TestCase
  test "should try and start the server if not running" do
    Hellanzb.expects(:start_server).once
    Hellanzb.expects(:new).raises(Errno::ECONNREFUSED).twice
    assert_raise(Hellanzb::ServerDown) { Hellanzb.client }
  end
end
