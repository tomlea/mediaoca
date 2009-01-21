require File.join(File.dirname(__FILE__), '..', 'test_helper')
require 'digest/md5'

class EpisodeTest < ActiveSupport::TestCase

  test "Should find by hash_code if asked by filename." do
    assert_equal Episode.for('foooo'), Episode.find_or_create_by_hash_code(Digest::MD5.hexdigest('foooo'))
  end

end
