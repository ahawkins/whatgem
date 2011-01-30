Then /^there should be this gem:$/ do |table|
  # table is a Cucumber::Ast::Table
  
  attributes = table.hashes.first

  RubyGem.exists?(attributes).should be_true
end

