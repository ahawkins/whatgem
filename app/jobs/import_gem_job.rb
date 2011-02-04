class ImportGemJob
  @queue = :high

  def self.perform(name)
    RubyGem.create_from_gemcutter!(Gemcutter::Gem.find(name))
  end
end
