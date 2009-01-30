class Show < ActiveRecord::Base
  has_many :episodes

  def self.guess_show(episode)
    normalize = lambda{|name| name.downcase.gsub(/[^a-z0-9]/, "")}
    all.find{|show|
      normalize[episode.filename].include? normalize[show.name]
    }
  end
end
