class Show < ActiveRecord::Base
  has_many :episodes do
    def latest
      @latest ||= reject(&:seen?).reject(&:unknown_episode?).sort_by(&:series_and_episode)
    end
  end

  def self.guess_show(episode)
    normalize = lambda{|name| name.downcase.gsub(/[^a-z0-9]/, "")}
    all.find{|show|
      normalize[episode.filename].include? normalize[show.name]
    }
  end
end
