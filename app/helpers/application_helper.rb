module ApplicationHelper

  def available_tags
    ActsAsTaggableOn::Tag.all.inject({}) do |hash, tag|
      hash[tag.name.titleize] = tag.name
      hash
    end
  end

  def gravatar_image(user, options = {})
    path = "http://www.gravatar.com/avatar/#{user.gravatar_id}"
    image_tag(path, options)
  end
end
