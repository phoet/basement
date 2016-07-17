# coding: utf-8

module ApplicationHelper
  def age
    birthday = Date.new(1980, 8, 27)
    age = Date.today.year - birthday.year
    age -= 1 if Date.today < birthday + age.years
    age
  end

  def names
    'Peter Schröder, Phoet, Señor Developer'
  end

  def keywords
    "#{names}, Ruby, Rails, Ruby on Rails, Software Development"
  end

  def website_url
    'www.phoet.de'
  end

  def menuitems
    Helper::menu.map{|m|m.subitems.map{|s|"#{m.id}/#{s.id}"}}.flatten
  end

  def app_info
    "<!-- Running on Rails #{Rails.version} and rendering took #{Time.new - @rendering_start} seconds -->".html_safe
  end

  def title(controller)
    Helper::menu.each do |m|
      cname = controller.controller_name
      m.subitems.each do |sub|
        aname = controller.action_name
        return "#{m.name} > #{sub.name}" if sub.id == aname
      end if m.id == cname
    end
  end

  def category_name(name)
    Helper::menu.find() do |m|
      m.id == name
    end.name
  end

  def menu(options={})
    top = options[:top].nil? || options[:top]
    current_controller = options[:controller] || controller.controller_name
    if top
      items = Helper::menu
    else
      items = Helper::menu.find() do |m|
        m.id == current_controller
      end.subitems
    end
    items.map do |i|
      page_options = (top ? {:controller => i.id} : {:controller => current_controller, :action => i.id})
      a = [current_controller, controller.action_name].include?(i.id)
      b = current_page?(page_options)
      cssclass = (a || b) ? ' class="current_page_item"' : ''
      link = link_to(i.name, page_options, {:title => i.name})
      "<li #{cssclass}>#{link}</li>\n"
    end.join.html_safe
  end

  def calc_difference(time_string)
    distance_of_time_in_words_to_now(time_string)
  end

  def links_4_twitter(text)
    ret = auto_link(text)
    regex = /(^|\s)#(\S+)/
    text.scan(regex) do |m|
      match = '#' + m[1]
      link = link_to match, "http://search.twitter.com/search?q=#{m[1]}"
      ret = ret.gsub(match, link)
    end
    text.scan(/@(\w+)/) do |m|
      match = '@' + m[0]
      link = link_to match, "http://twitter.com/#{m[0]}"
      ret = ret.gsub(match, link)
    end
    ret.html_safe
  end
end
