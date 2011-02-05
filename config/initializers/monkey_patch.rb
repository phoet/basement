# patch I18n to automatically make a DateTime from a String
module I18n
  class << self
    alias :localize_old :localize
    def localize(object, options = {})
      object = DateTime.parse(object) if object.is_a? String
      localize_old(object, options)
    end
  end
end

