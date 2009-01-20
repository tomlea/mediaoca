class EpisodesController < ApplicationController
  ROOT="/home/norman/Desktop/NZB/TV"
  # ROOT="/Users/norman/nzb"

  def index
    @episodes = all_episodes
  end
  
  def show
    @episode = all_episodes.find{|e| e == params[:episode] }
    MediaController::Client.new.play(@episode)
    redirect_to :action => "index"
  end
  
  def all_episodes
    @episodes ||= Dir.glob("#{ROOT}/**/*.{avi,wmv}").sort
  end
end
