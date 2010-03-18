require 'mash'

class Seitwert
  def initialize(xml)
    @mash = Mash.new(xml['urlinfo'])
  end
  
  def seitwert
    @mash.seitwert
  end
  
  def alexa
    @mash.alexa
  end
  
  def google
    @mash.google
  end
  
  def yahoo
    @mash.yahoo
  end
  
  def social
    @mash.social
  end
  
  def technical
    @mash.technical
  end
  
end