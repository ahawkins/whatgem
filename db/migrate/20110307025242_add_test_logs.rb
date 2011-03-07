class AddTestLogs < ActiveRecord::Migration
  def self.up
    add_column :ruby_gems, :test_log, :text
    add_column :ruby_gems, :test_results, :float
    remove_column :ruby_gems, :has_tests
    remove_column :ruby_gems, :has_features
  end

  def self.down
    remove_column :ruby_gems, :test_log
    remove_column :ruby_gems, :test_results
    add_column :ruby_gems, :has_tests, :boolean
    add_column :ruby_gems, :has_features, :boolean
  end
end
