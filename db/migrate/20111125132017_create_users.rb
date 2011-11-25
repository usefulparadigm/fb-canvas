class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.column :fb_user_id, :bigint
      t.string :oauth_token
      t.text :data
      
      t.timestamps
    end
    add_index :users, :fb_user_id
  end

  def self.down
    remove_index :users, :fb_user_id
    drop_table :users
  end
end
