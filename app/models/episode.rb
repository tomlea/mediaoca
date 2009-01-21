class Episode < ActiveRecord::Base
  def self.file_digest(file)
    Digest::MD5.hexdigest(file)
  end
  
  def self.find_or_create_by_filename(filename)
    find_or_create_by_hash_code(file_digest(filename))
  end
  
  def self.for(name)
    find_or_create_by_filename(name)
  end
end
