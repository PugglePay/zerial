require 'zerial/base_serializer'

module Zerial
  module DateSerializer
    extend BaseSerializer

    def self.as_json(object)
      object.as_json
    end

    def self.from_loaded_json (json)
      Date.parse(json)
    end
  end
end
