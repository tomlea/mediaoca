require "digest/md5"
module EpisodesHelper
  def link_to_play(text, episode)
    link_to(text, :action => "show", :episode => episode)
  end

  def link_to_seen(text, episode)
    link_to(text, :action => "seen", :episode => episode)
  end
  
  def file_digest(file)
    Digest::MD5.hexdigest(file)
  end
end
