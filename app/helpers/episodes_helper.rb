require "digest/md5"
module EpisodesHelper
  def link_to_play(file)
    link_to(File.basename(file), :action => "show", :episode => file_digest(file))
  end
  
  def file_digest(file)
    Digest::MD5.hexdigest(file)
  end
end
