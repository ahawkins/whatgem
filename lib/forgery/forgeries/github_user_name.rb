class Forgery::GithubUserName < Forgery
  def self.name
    dictionaries[:github_user_names].random
  end
end
