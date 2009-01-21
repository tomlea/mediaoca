class EpisodesController < ApplicationController
  ROOT="/home/norman/Desktop/NZB/TV"
  # ROOT="/Users/norman/nzb"

  def index
    @episodes = all_episodes
    currently_playing = media_controller.currently_playing
    @currently_playing = currently_playing && File.basename(currently_playing)
    @paused = media_controller.paused
  end
  
  def show
    @episode = all_episodes.find{|e| e == params[:episode] }
    media_controller.play(@episode)
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
  def media_controller
    @media_controller ||= MediaController::Client.new
  end
  
  def all_episodes
    @episodes ||= Dir.glob("#{ROOT}/**/*.{avi,wmv}").sort
  end
end
