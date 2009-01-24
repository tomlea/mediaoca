class Episode < ActiveRecord::Base
  def self.file_digest(file)
    Digest::MD5.hexdigest(file)
  end
  
  def self.find_or_create_by_filename(filename)
    find_or_create_by_hash_code(file_digest(filename))
  end
  
  def self.for(name)
    returning find_or_create_by_filename(name) do |e|
      e.filename = name
    end
  end
  
  def self.clenseables
    YAML.load(File.open(File.join(Rails.root, "config", "clenseables.yml")))
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
        name.gsub!(" +"," ")
      end
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
