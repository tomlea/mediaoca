class HomeController < ApplicationController
  def index
    @last_watched = Show.all.select{|show| show.episodes.unwatched.any? and show.episodes.watched.any? }.sort_by{|show| show.episodes.watched.map(&:last_watched).max }.reverse.first(5)
    @shows_with_new_episodes = Show.all.select{|show| show.episodes.unwatched.any? }.sort_by{|show| - show.episodes.unwatched.size }
    @fresh_episodes = Show.most_recently_updated.reject{|show| show.episodes.last_changed < 7.days.ago }.reject{|show| show.episodes.all?(&:seen?)}
  end
end
