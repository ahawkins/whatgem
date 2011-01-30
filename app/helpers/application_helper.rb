module ApplicationHelper

  def available_tags
    ActsAsTaggableOn::Tag.all.inject({}) do |hash, tag|
      hash[tag.name.titleize] = tag.name
      hash
    end
  end
end
