class AddShowFilename < ActiveRecord::Migration
  def self.up
    add_column :episodes, :filename, :string
  end

  def self.down
    remove_column :episodes, :filename
  end
end
