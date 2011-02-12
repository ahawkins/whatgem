module RSpec::Rails
  module ObserverExampleGroup
    extend ActiveSupport::Concern
    extend RSpec::Rails::ModuleInclusion

    include RSpec::Rails::RailsExampleGroup

    def observer
      example.example_group.describes.instance
    end

    included do
      metadata[:type] = :observer
    end

    RSpec.configure do |c|
      c.include self, :example_group => { :file_path => /spec\/observers/ }
    end
  end
end

