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
    media_controller.stop
    fetch_currently_playing
    update_currently_playing
  end

  def pause
    media_controller.pause
    fetch_currently_playing
    update_currently_playing
  end
  
private
  def update_episode
    respond_to do |format|
      format.js   { render :action => :update, :layout => false }
      format.html { redirect_to :action => "index" }
    end
  end
  
  def update_currently_playing
    respond_to do |format|
      format.js   { render :action => :update_currently_playing, :layout => false }
      format.html { redirect_to :action => "index" }
    end
  end
  
  def fetch_currently_playing
    @currently_playing = media_controller.currently_playing
    @currently_playing = File.basename(@currently_playing) if @currently_playing
    @paused = media_controller.paused
  end
  before_filter :fetch_currently_playing, :except => [:play, :stop, :pause]
    
  def episode
    @episode ||= all_episodes.find{|e|
        e.hash_code == params[:episode]
      }
  end
  helper_method :episode

  def media_controller
    @media_controller ||= MediaController::Client.new
  end
  
  def all_episodes
    @episodes ||= media_paths.inject([]){|acc, path|
      acc + Dir.glob("#{path}/**/*.{avi,wmv,divx,mkv}")
    }.map{|filename|
      Episode.for(filename)
    }.sort_by{|episode|
      [episode.seen ? 1 : 0, episode.name.downcase]
    }
  end
  
  def media_paths
    @media_paths ||= YAML.load(File.open(File.join(Rails.root, "config", "media_paths.yml")))
  end
end
