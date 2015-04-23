module Zerial
  class Maybe
    include BaseSerializer
    attr_reader :serializer

    def initialize (serializer)
      @serializer = serializer
    end

    def as_json (object)
      object ? serializer.as_json(object) : nil
    end

    def from_loaded_json (json)
      json ? serializer.from_loaded_json(json) : nil
    end
  end
end
