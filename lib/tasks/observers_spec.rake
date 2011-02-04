require 'rspec/core'
require 'rspec/core/rake_task'
Rake.application.instance_variable_get('@tasks')['default'].prerequisites.delete('test')

spec_prereq = Rails.configuration.generators.options[:rails][:orm] == :active_record ?  "db:test:prepare" : :noop

namespace :spec do
  [:observers].each do |sub|
    desc "Run the code examples in spec/#{sub}"
    RSpec::Core::RakeTask.new(sub => spec_prereq) do |t|
      t.pattern = "./spec/#{sub}/**/*_spec.rb"
    end
  end
end

