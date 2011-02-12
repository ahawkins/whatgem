class RelatedGems < ActiveRecord::Migration
  def self.up
    create_table :related_gems, :id => false do |t|
      t.references :parent
      t.references :child
    end
  end

  def self.down
  end
end
