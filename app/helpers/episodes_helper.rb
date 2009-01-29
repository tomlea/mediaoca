require "digest/md5"
module EpisodesHelper
  def link_to_play(text, episode, options = {})
    link_to_remote(text, {:url => {:action => "play", :episode => episode}}, options)
  end

  def link_to_seen(text, episode, options = {})
    link_to_remote(text, {:url => {:action => "seen", :episode => episode}}, options)
  end
  
  def file_digest(file)
    Digest::MD5.hexdigest(file)
  end
end
