class RelatedGemsObserver < ActiveRecord::Observer
  observe RubyGem

  SPECIAL_PREFIXES = {
    'dm' => 'datamapper',
    'ey' => 'engineyard'
  }

  def after_create(ruby_gem)
    # the gem is is named like capistrano-ext, so search for a gem
    # named the prefix
    if matches = ruby_gem.name.match(/(\w+)[\-_].+$/)
      gem_name = SPECIAL_PREFIXES[matches[1]] ? SPECIAL_PREFIXES[matches[1]] : matches[1]

      related_gem = RubyGem.named gem_name
      ruby_gem.related_gems << related_gem if related_gem

      RubyGem.where('(LOWER(name) LIKE ? OR LOWER(name) LIKE ?) AND id != ?', "#{gem_name.downcase}%", "#{matches[1].downcase}%", ruby_gem.id).each do |related_gem|
        ruby_gem.related_gems << related_gem
      end
    else
      # find gems beginning with the prefix
      inverted = SPECIAL_PREFIXES.invert
      search = inverted[ruby_gem.name] ? "#{inverted[ruby_gem.name.downcase]}%" : "#{ruby_gem.name}%"

      RubyGem.where('LOWER(name) LIKE ? AND id != ?', search, ruby_gem.id).each do |related_gem|
        ruby_gem.related_gems << related_gem
      end
    end
  end
end
