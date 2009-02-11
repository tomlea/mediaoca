class Episode < ActiveRecord::Base
  EPISODE_MATCHERS = [/([0-9]{1,2})x([0-9]{1,2})/i, /s([0-9]{1,2})e([0-9]{1,2})/i]
  belongs_to :show

  class << self
    def file_digest(file)
      Digest::MD5.hexdigest(file)
    end

    def find_or_create_by_filename(filename)
      hash = file_digest(File.basename(filename))
      if ep = find_by_hash_code(file_digest(filename))
        ep.update_attribute(:hash_code, hash)
        ep
      else
        find_or_create_by_hash_code(hash)
      end
    end

    def for(filename)
      returning find_or_create_by_filename(filename) do |e|
        e.filename = filename
        e.show ||= Show.guess_show(e)
        e.save!
      end
    end

    def clenseables
      YAML.load(File.open(File.join(Rails.root, "config", "clenseables.yml")))
    end

    def media_paths
      @media_paths ||= YAML.load(File.open(File.join(Rails.root, "config", "media_paths.yml")))
    end

    def all
      if @episodes and @episodes_updated > Time.now - 5.minutes
        @episodes
      else
        @episodes_updated = Time.now
        @episodes = media_paths.inject([]){|acc, path|
          acc + Dir.glob("#{path}/**/*.{avi,wmv,divx,mkv,ts,mov,mp4}")
        }.map{|filename|
          Episode.for(filename)
        }
      end
    end

    def scan_for_episodes!
      media_paths.each{|path|
        Dir.glob("#{path}/**/*.{avi,wmv,divx,mkv,ts,mov,mp4}")
      }.flatten.map{|filename|
        Episode.for(filename)
      }
    end

    def clean_up_deleted_episodes!
      @episodes.each do |episode|
        episode.destroy! if episode.filename.nil? or not File.exist?(episode.filename)
      end
    end
  end

  def to_param
    hash_code
  end

  def name
    returning File.basename(filename) do |name|
      name[/\.[^.]+$/] = ""
      name.gsub!("."," ")
      self.class.clenseables.each do |clenseable|
        name.gsub!(clenseable, "")
        name.sub!(/#{show.name}/, "") if show
        EPISODE_MATCHERS.each do |em|
          name.sub!(em, "") if series_and_episode
        end
        name.gsub!(" +"," ")
      end
    end
  end

  def series
    series_and_episode && series_and_episode.first
  end

  def episode
    series_and_episode && series_and_episode.last
  end

  def series_and_episode
    if EPISODE_MATCHERS.any?{|re| filename =~ re }
      [$1.to_i, $2.to_i]
    else
      nil
    end
  end

  def seen
    last_watched?
  end

  def seen?
    last_watched?
  end

  def seen!
    self.seen = true
  end

  def seen=(bool)
    update_attribute(:last_watched, bool ? Time.now : nil)
  end

  attr_accessor :filename
end
