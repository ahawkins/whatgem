class TestGemJob
  @queue = :high

  def self.perform(name)
    ruby_gem = RubyGem.named name
    repo_url = ruby_gem.github_url.chomp.gsub(/https?/,'git') + '.git'
    repo_name = ruby_gem.github_url.split('/').last

    bash_script = Rails.root.join('bash','test_repo.sh')

    ruby_gem.test_log = %x{#{bash_script} #{repo_url}}

    ruby_gem.save!
  end
end
