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

  test "should not find episodes with sample in their names" do
    Episode.stubs(:media_paths).returns(["some_foo"])
    Dir.stubs(:glob).returns(["this is a move called the sampler", "movie - sample.png", "this.is.a.sample.avi", "this.is.a.sample-divx.avi"])
    Episode.expects(:for).with("this is a move called the sampler").once
    Episode.scan_for_episodes!
  end

  test "should match an AVI" do
    Episode.stubs(:media_paths).returns(["some_foo"])
    Dir.stubs(:glob).returns(["this.is.a.movie-divx.avi"])
    Episode.expects(:for).with("this.is.a.movie-divx.avi").once
    Episode.scan_for_episodes!
  end
end
