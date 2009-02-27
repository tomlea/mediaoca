class Show < ActiveRecord::Base
  has_many :episodes do
    def latest
      @latest ||= reject(&:seen?).sort_by{|e| e.series_and_episode ? e.series_and_episode : [0,0]}
    end
  end

  after_create do
    Episode.detect_missing_shows!
  end

  def self.guess_show(episode)
    normalize = lambda{|name| name.downcase.gsub(/[^a-z0-9]/, "")}
    all.find{|show|
      normalize[episode.filename].include? normalize[show.name]
    }
  end
end
