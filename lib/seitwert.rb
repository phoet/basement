class Seitwert
  def initialize(xml)
    @data = Hashie::Mash.new(xml['urlinfo'])
  end
  
  def seitwert
    @data.seitwert
  end
  
  def alexa
    @data.alexa
  end
  
  def google
    @data.google
  end
  
  def yahoo
    @data.yahoo
  end
  
  def social
    @data.social
  end
  
  def technical
    @data.technical
  end
  
end