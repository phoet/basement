class GoogleData

  def initialize(json)
    @json = json
  end

  def id
    @json["id"]["$t"]
  end

  def title
    @json['title']['$t']
  end

  def author_name
    @json["author"][0]["name"]["$t"]
  end

  def author_url
    @json["author"][0]["uri"]["$t"]
  end

  def published
    date = @json['published']['$t']
    date = Date.parse(date) if date.is_a? String
    date.strftime('%d.%m.%Y')
  end

  def tags
    @json["category"].map { |c| c['term'] } if @json["category"]
  end

end
