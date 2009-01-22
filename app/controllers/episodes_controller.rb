class EpisodesController < ApplicationController
  include EpisodesHelper
  
  def check_currently_playing
    @currently_playing_thread = thread do
      currently_playing = media_controller.currently_playing
      @currently_playing = currently_playing && File.basename(currently_playing)
    end
  end
  
  def currently_playing
    Timeout.timeout(3){ @currently_playing_thread.join } rescue nil
    @currently_playing
  end
  
  def index
    currently_playing
    @episodes = all_episodes
    @paused = media_controller.paused
  end
  
  def show
    media_controller.play(episode.filename)
    episode.seen!
    redirect_to :action => "index"
  end
  
  def seen
    episode.seen = ! episode.seen
    update_episode
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
  def update_episode
    respond_to do |format|
      format.js   { render :action => :update, :layout => false }
      format.html { redirect_to :action => "index" }
    end
  end
  
  def episode
    @episode ||= Episode.for(all_episodes.find{|e| file_digest(e) == params[:episode] })
  end
  helper_method :episode

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
