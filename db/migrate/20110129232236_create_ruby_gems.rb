class CreateRubyGems < ActiveRecord::Migration
  def self.up
    create_table :ruby_gems do |t|
      t.string :name, :unique => true
      t.string :description
      t.references :user
      t.timestamps
    end

    add_index :ruby_gems, :name, :unique => true
  end

  def self.down
    drop_table :ruby_gems
  end
end
