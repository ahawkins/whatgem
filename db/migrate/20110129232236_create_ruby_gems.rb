class CreateRubyGems < ActiveRecord::Migration
  def self.up
    create_table :ruby_gems do |t|
      t.string :name, :unique => true
      t.string :description
      
      t.integer :number_of_closed_issues
      t.integer :number_of_open_issues
      t.integer :number_of_open_pull_requests
      t.integer :number_of_closed_pull_requests
      
      t.boolean :has_readme
      t.boolean :has_license
      t.boolean :has_tests
      t.boolean :has_examples
      t.boolean :has_features

      t.float  :rating

      t.string :github_url
      t.string :documentation_url

      t.references :user
      t.timestamps
    end

    add_index :ruby_gems, :name, :unique => true
  end

  def self.down
    drop_table :ruby_gems
  end
end
