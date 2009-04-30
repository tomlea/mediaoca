class HomeController < ApplicationController
  def index
    @fresh_episodes = Show.most_recently_updated.reject{|show| show.episodes.last_changed < 7.days.ago }
  end
end
