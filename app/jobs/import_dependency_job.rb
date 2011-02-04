class ImportDependencyJob
  @queue = :low

  def self.perform(gem_name)
    gemcutter = Gemcutter::Gem.find gem_name

    dependencies = gemcutter.dependencies['runtime'] + gemcutter.dependencies['development']

    dependency_names = dependencies.reject(&:blank?).map {|dep| dep['name']}

    dependency_names.each do |dependency_name|
      if !RubyGem.named dependency_name
        Resque.enqueue ImportGemJob, dependency_name
      end
    end
  end
end
