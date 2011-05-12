class CreateGemDependencies < ActiveRecord::Migration
  def self.up
    create_table :dependencies do |t|
      t.references :ruby_gem
      t.references :dependent_ruby_gem

      t.timestamps
    end

    add_index :dependencies, :ruby_gem_id
    add_index :dependencies, :dependent_ruby_gem_id
  end

  def self.down
    drop_table :dependencies
  end
end
