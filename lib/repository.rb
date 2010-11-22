class Repository
  def initialize(json)
    @repo = Hashie::Mash.new json
  end  
end