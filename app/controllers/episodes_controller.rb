class EpisodesController < ApplicationController
  include EpisodesHelper
  
  def index
    @episodes = all_episodes
  end
  
  def play
    media_controller.play(episode.filename)
    episode.seen!
    fetch_currently_playing
    update_episode
  end
  
  def seen
    episode.seen = ! episode.seen
    update_episode
  end
  
  def stop
    fetch_currently_playing
    media_controller.stop
    @stopped_episode = @currently_playing_episode
    fetch_currently_playing
    update_currently_playing
  end

  def pause
    media_controller.pause
    fetch_currently_playing
    update_currently_playing
  end
  
  def update_currently_playing
    fetch_currently_playing unless @currently_playing_episode
    respond_to do |format|
      format.js   { render :action => :update_currently_playing, :layout => false }
      format.html { redirect_to :action => "index" }
    end
  end
  
  def detail
    respond_to do |format|
      format.js
    end
  end
  
private
  def update_episode
    respond_to do |format|
      format.js   { render :action => :update, :layout => false }
      format.html { redirect_to :action => "index" }
    end
  end
    
  def episode
    @episode ||= all_episodes.find{|e|
        e.hash_code == params[:episode]
      }
  end
  helper_method :episode
  
  def all_episodes
    @episodes ||= media_paths.inject([]){|acc, path|
      acc + Dir.glob("#{path}/**/*.{avi,wmv,divx,mkv,ts,mov,mp4}")
    }.map{|filename|
      Episode.for(filename)
    }.sort_by{|episode|
      [
        episode.seen ? 1 : 0,
        episode.show && episode.show.name || "",
        episode.series || 0,
        episode.episode  || 0,
        episode.name.downcase
      ]
    }
  end
  
  def media_paths
    @media_paths ||= YAML.load(File.open(File.join(Rails.root, "config", "media_paths.yml")))
  end
end
