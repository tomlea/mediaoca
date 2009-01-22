class EpisodesController < ApplicationController
  include EpisodesHelper
  def index
    @episodes = all_episodes
    currently_playing = media_controller.currently_playing
    @currently_playing = currently_playing && File.basename(currently_playing)
    @paused = media_controller.paused
  end
  
  def show
    media_controller.play(episode.filename)
    episode.seen!
    redirect_to :action => "index"
  end
  
  def seen
    episode.seen = ! episode.seen
    redirect_to :action => "index"
  end
  
  def stop
    media_controller.stop
    redirect_to :action => "index"
  end

  def pause
    media_controller.pause
    redirect_to :action => "index"
  end
  
private
  def episode
    @episode ||= Episode.for(all_episodes.find{|e| file_digest(e) == params[:episode] })
  end

  def media_controller
    @media_controller ||= MediaController::Client.new
  end
  
  def all_episodes
    p media_paths
    @episodes ||= media_paths.inject([]){|acc, path| acc + Dir.glob("#{path}/**/*.{avi,wmv,divx,mkv}")}.sort
  end
  
  def media_paths
    @media_paths ||= YAML.load(File.open(File.join(Rails.root, "config", "media_paths.yml")))
  end
end
