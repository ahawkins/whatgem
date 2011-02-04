class UpdateRatingJob
  @queue = :high

  def self.perform(ruby_gem_id)
    ruby_gem = RubyGem.find ruby_gem_id
    ruby_gem.from_gemcutter(Gemcutter::Gem.find(ruby_gem.name)).save!
  end
end
