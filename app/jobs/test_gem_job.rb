class TestGemJob
  @queue = :high

  def self.perform(name)
    ruby_gem = RubyGem.named name
    repo_url = ruby_gem.github_url.chomp.gsub(/https?/,'git') + '.git'
    repo_name = ruby_gem.github_url.split('/').last

    bash_script = Rails.root.join('bash','test_repo.sh')
    log_path = Rails.root.join('tmp','test_logs',"#{repo_name}.log")

    cmd = "#{bash_script} #{repo_url} > #{log_path}"
    %x(#{bash_script} #{repo_url} > #{log_path})

    ruby_gem.test_log = File.read log_path
    ruby_gem.save!
  end
end
