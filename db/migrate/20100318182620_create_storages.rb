class CreateStorages < ActiveRecord::Migration
  def self.up
    create_table :storages do |t|
      t.string :key
      t.text :data

      t.timestamps
    end
  end

  def self.down
    drop_table :storages
  end
end
