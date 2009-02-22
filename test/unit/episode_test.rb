require File.join(File.dirname(__FILE__), '..', 'test_helper')
require 'digest/md5'

class EpisodeTest < ActiveSupport::TestCase
  test "should be associated with the correct show" do
    Show.create!(:name => "aaa")
    foo = Show.create!(:name => "foo")
    Show.create!(:name => "zzz")
    ep = Episode.for("foo - 1x1 - my arse.avi")
    assert_equal foo, ep.show
  end
end
