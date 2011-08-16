require 'spec_helper'

describe ApplicationHelper do

  it "should create links on twitter posts" do
    text = "#hamburg_on_ruby building on @travisci http://travis-ci.org/#!/phoet/hamburg_on_ruby"
    result = links_4_twitter(text)
    result.should eql("<a href=\"http://search.twitter.com/search?q=hamburg_on_ruby\">#hamburg_on_ruby</a> building on <a href=\"http://twitter.com/travisci\">@travisci</a> <a href=\"http://travis-ci.org/#!/phoet/hamburg_on_ruby\">http://travis-ci.org/#!/phoet/hamburg_on_ruby</a>")
  end

end
