class ImportGemJob
  @queue = :medium

  def self.perform(name)
    gemcutter = Gemcutter::Gem.find name

    # since we only track gems that use git for source control,
    # guard against that here. This way we don't get
    # failed jobs when the gem does not meet the tracking
    # requirements.
    return if gemcutter.github_repo.blank?

    RubyGem.create_from_gemcutter!(Gemcutter::Gem.find(name))
  end

  def self.on_failure(exception, *args)
    if exception.is_a?(Github::RateLimitExceeded)
      puts "Hit github rate limit...will try again later"
      sleep(60) # wait for a minute. Github throttles per minute
      Resque.enqueue self, *args
    end
  end
end
