class CreateVotes < ActiveRecord::Migration
  def self.up
    create_table :votes do |t|
      t.references :ruby_gem
      t.references :user
      t.boolean :up
      t.timestamps
    end

    add_index :votes, :ruby_gem_id
    add_index :votes, :user_id
    add_index :votes, :up
  end

  def self.down
    drop_table :votes
  end
end
