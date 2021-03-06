class Show < ActiveRecord::Base
  has_many :episodes, :extend => Episode::CollectionMethods

  after_create do
    Episode.detect_missing_shows!
  end

  def to_param
    "#{id}-#{name.gsub(/ /, "-").dasherize}"
  end

  class << self
    def guess_show(episode)
      normalize = lambda{|name| name.downcase.gsub(/[^a-z0-9]/, "")}
      all.find{|show|
        normalize[episode.filename].include? normalize[show.name]
      }
    end

    def most_recently_updated
      Show.all.select{|show| show.episodes.any? }.sort_by{|show| show.episodes.last_changed }.reverse
    end
  end
end
