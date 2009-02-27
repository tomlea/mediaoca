class CreateShowIdIndexOnEpisodes < ActiveRecord::Migration
  def self.up
    add_index :episodes, :show_id
  end

  def self.down
    remove_index :episodes, :show_id
  end
end
