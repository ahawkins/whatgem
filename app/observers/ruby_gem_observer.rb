class RubyGemObserver < ActiveRecord::Observer

  def after_create(ruby_gem)
    Resque.enqueue ImportDependencyJob, ruby_gem.name
  end

end
