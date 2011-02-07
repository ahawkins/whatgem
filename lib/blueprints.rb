require 'machinist/active_record'

class ActiveRecord::Base
  def self.random
    if (c = count) != 0
      first(:offset => rand(c))
    end
  end
end


range = (1..100).to_a

User.blueprint do
  name { Forgery::GithubUserName.name }
end

RubyGem.blueprint do
  name { Forgery::GemName.name }
  description { Forgery::LoremIpsum.sentence }
  
  number_of_closed_issues { range[rand(range.size)] }
  number_of_open_issues { range[rand(range.size)] }

  number_of_open_pull_requests { range[rand(range.size)] }
  number_of_closed_pull_requests { range[rand(range.size)]  }

  has_readme { rand(1) == 1 }
  has_license { rand(1) == 1  }
  has_tests { rand(1) == 1  }
  has_examples { rand(1) == 1  }
  has_features { rand(1) == 1  }

  github_url { "https://github.com/#{name}/#{name}"}
  github_url { "https://rdoc.info/#{name}/#{name}"}

  user { User.find_or_create_by_name!(Forgery::GithubUserName.name) }
end

Comment.blueprint do
  user { User.random }
  ruby_gem { RubyGem.random }
  text { Forgery::LoremIpsum.paragraphs(2) }
end
