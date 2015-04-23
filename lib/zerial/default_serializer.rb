require 'zerial/base_serializer'

module Zerial
  module DefaultSerializer
    extend BaseSerializer

    def self.as_json (object)
      object.as_json
    end

    def self.from_loaded_json (json)
      json
    end
  end
end
