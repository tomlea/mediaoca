require File.join(File.dirname(__FILE__), '..', 'test_helper')

class ShowTest < ActiveSupport::TestCase
  test "should try and gather unmatched episodes upon create" do
    ep = Episode.for("foo - 1x1 - my arse.avi")
    foo = Show.create!(:name => "foo")
    ep.reload
    assert_equal foo, ep.show
  end
end
