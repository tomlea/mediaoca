class CreateEpisodes < ActiveRecord::Migration
  def self.up
    create_table :episodes do |t|
      t.string :hash_code
      t.datetime :last_watched

      t.timestamps
    end
  end

  def self.down
    drop_table :episodes
  end
end
