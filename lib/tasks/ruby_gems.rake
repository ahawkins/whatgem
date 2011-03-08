namespace :ruby_gems do
  desc "Scrape a list of all gem names from RubyGems.org and add them to the processing queues"
  task :scrape => :environment do
    agent = Mechanize.new

    ('A'..'Z').each do |letter|
      puts "Fetching #{letter}'s Index"

      page = agent.get "http://rubygems.org/gems?letter=#{letter}"
      last_page_link = page.search(%Q{.//div[contains(@class, 'pagination')]/a[last()-1]}).first
      total_pages = last_page_link.attributes['href'].value.match(/page=(\d+)/)[1]

      puts "Found #{total_pages} pages"

      (1..total_pages.to_i).each do |current_page|
        puts "Processing #{letter} (#{current_page}/#{total_pages})"

        url = "http://rubygems.org/gems?letter=#{letter}&page=#{current_page}"
        page = agent.get url

        page.search(".//div[contains(@class, 'gems')]/ol/li").each do |li|
          link_text = li.search('a/strong').text
          gem_name = link_text.match(/(.+)\s\(/)[1]
          downloads = li.search(%Q{div[@class='downloads']/strong}).text

          if downloads.to_i >= 1000 && RubyGem.named(gem_name).blank?
            puts "#{gem_name} added to import queue"
            Resque.enqueue(ImportGemJob, gem_name)
          elsif RubyGem.named(gem_name)
            puts "#{gem_name} scheduled for update"
            Resque.enqueue(UpdateRatingJob, gem_name)
          end
        end
      end
    end
  end

  desc "Run tests for all Gems in the db"
  task :test => :environment do
    RubyGem.order('updated_at asc').each do |ruby_gem|
      repo_url = ruby_gem.github_url.chomp.gsub(/https?/,'git') + '.git'
      repo_name = ruby_gem.github_url.split('/').last

      bash_script = Rails.root.join('bash','test_repo.sh')

      cmd = "/bin/bash -l -c '#{bash_script} #{repo_url}'"
      ruby_gem.test_log = %x{echo "Running: #{cmd}" ; #{cmd}}

      ruby_gem.save!
    end
  end

  desc "Rescore all gems" 
  task :rescore => :environment do
    RubyGem.all.map(&:save!)
  end
end
