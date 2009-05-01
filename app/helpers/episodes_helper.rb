require "digest/md5"
module EpisodesHelper
  def link_to_play(episode, text = "play")
    link_to_remote text, {:url => {:controller => :episodes, :action => "play", :id => episode}}, {:class => "play", :href => url_for(:controller => :episodes, :action => "play", :id => episode)}
  end

  def link_to_seen(episode)
    link_to_remote "toggle seen", {:url => {:controller => :episodes, :action => "seen", :id => episode}}, {:class => "seen", :href => url_for(:controller => :episodes, :action => "seen", :id => episode)}
  end

  def link_to_stop
    link_to_remote "stop", :url => stop_url, :html => {:class => "stop", :href => url_for(:controller => :episodes, :controller => :episodes, :action => "stop")}
  end

  def link_to_pause(options = {})
    link_to_remote "play/pause", {:url => pause_url, :html => {:class => "pause", :href => url_for(:controller => :episodes, :action => "pause")}.merge(options)}
  end

  def stop_url
    {:controller => :episodes, :action => "stop"}
  end

  def pause_url
    {:controller => :episodes, :action => "pause"}
  end

  def currently_playing?(episode = :anything)
    @currently_playing_episode == episode or episode == :anything and not @currently_playing_episode.nil?
  end

  def currently_playing_name
    h File.basename(@currently_playing_episode.filename)
  end

  def show_name(episode)
    show_name = episode.show && h(episode.show.name)
    (episode.series_and_episode ? "%s %02ix%02i" : "%s") % [show_name, episode.series, episode.episode]
  end
end
