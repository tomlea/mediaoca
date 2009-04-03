class RemoveSamples < ActiveRecord::Migration
  def self.up
    Episode.delete_all("filename like '%sample%'")
  end

  def self.down
  end
end
