class EpisodesController < ApplicationController
  include EpisodesHelper

  def index
    response.last_modified = all_episodes.map{|e| e.updated_at}.max
    response.etag = all_episodes
    if request.fresh?(response)
      head :not_modified
    else
      @episodes = all_episodes.sort
    end
  end

  def min
    fetch_currently_playing
    render :layout => false
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
    @episode = Episode.find(params[:id])
  end
  helper_method :episode

  def all_episodes
    @all_episodes ||= Episode.all(:include => :show)
  end
end
