class UpdateRatingJob
  @queue = :low

  def self.perform(name)
    ruby_gem = RubyGem.named(name)
    ruby_gem.from_gemcutter(Gemcutter::Gem.find(ruby_gem.name)).save!
  end
end
