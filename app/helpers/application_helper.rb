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

  def ribbon(*args, &block)
    html_options = args.extract_options!
    title = args.first

    html_options[:class] ||= ''
    html_options[:class] += ' ribbon'

    if title
      ribbon = content_tag(:h2, title, html_options, &block)
    else
      ribbon = content_tag(:h2, html_options, &block)
    end

     triangle = content_tag(:div, '', :class => 'triangle-ribbon')
     ribbon + triangle + content_tag(:div, '', :class => 'ribbon-clear')
  end

  def full_ribbon(*args, &block)
    html_options = args.extract_options!
    title = args.first

    html_options[:class] ||= ''
    html_options[:class] += ' full'

    ribbon(*[title, html_options], &block)
  end

  def icon_for_flag(flag, options = {})
    path = flag == true ? 'success.png' : 'error.png'
    image_tag(path, options)
  end

  def html5_logo
    img = image_tag "http://www.w3.org/html/logo/badge/html5-badge-h-css3-semantics.png",
      :width => "165",  :height => "64", 
      :alt => "HTML5 Powered with CSS3 / Styling, and Semantics", 
      :title => "HTML5 Powered with CSS3 / Styling, and Semantics"

    link_to img, 'http://www.w3.org/html/logo/'
  end
end
