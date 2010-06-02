# coding: utf-8

module ApplicationHelper
  def age
    birthday = Date.new(1980,8,27)
    age = Date.today.year - birthday.year
    age -= 1 if Date.today < birthday + age.years
    age
  end

  def names
    'Peter Schröder, Phoet, Uschi, Onkel Klaus'
  end

  def keywords
    'Privates, Fachliches und Interessantes'
  end

  def website_url
    'www.phoet.de'
  end

  def menuitems
    Helper::menu.map{|m|m.subitems.map{|s|"#{m.id}/#{s.id}"}}.flatten
  end

  def trim_to(text, length)
    text.size > length ? text[0..(length-1)] + '...' : text
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
      cssclass = ([current_controller, controller.action_name].include?(i.id) || current_page?(page_options)) ? ' class="current_page_item"' : ''
      link = link_to(i.name, page_options, {:title => i.name})
      "<li #{cssclass}>#{link}</li>\n"
    end.join.html_safe
  end

  def calc_difference(time_string)
    minutes = (Time.new - Time.parse(time_string)).to_i / 60
    if minutes == 0
      'wenigen Sekunden'
    elsif minutes < 60
      'ein paar Minuten'
    elsif minutes < 60 * 24
      'einigen Stunden'
    elsif minutes < 60*24*7
      'Tagen'
    else
      'langer Zeit'
    end
  end

  def links_4_urls(text)
    ret = text.dup
    title = text.gsub /[^\w]/, ' '
    URI::extract(text, ['http','https']) do |match|
      link = "<a href='#{match}' title='#{title}'>#{match}</a>"
      ret.gsub!(match, link)
    end
    ret.html_safe
  end

  def links_4_twitter(text)
    ret = links_4_urls(text)
    title = text.gsub(/[^\w]/, ' ')
    regex = /#(\S+)/
    text.scan(regex) do |m|
      match = '#' + m[0]
      link = "<a href='http://search.twitter.com/search?q=#{m[0]}' title='#{title}'>#{match}</a>"
      ret.gsub!(match, link)
    end
    text.scan(/@(\w+)/) do |m|
      match = '@' + m[0]
      link = "<a href='http://twitter.com/#{m[0]}' title='#{title}'>#{match}</a>"
      ret.gsub!(match, link)
    end
    ret.html_safe
  end
end
