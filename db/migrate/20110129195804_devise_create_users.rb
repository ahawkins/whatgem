class DeviseCreateUsers < ActiveRecord::Migration
  def self.up
    create_table(:users) do |t|
      t.rememberable
      t.trackable
      t.token_authenticatable

      t.string :gravatar_id

      t.string :name, :unique => true

      t.timestamps
    end

    add_index :users, :name, :unique => true
    add_index :users, :authentication_token, :unique => true
  end

  def self.down
    drop_table :users
  end
end
