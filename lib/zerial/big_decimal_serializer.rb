require 'zerial/base_serializer'

module Zerial
  module BigDecimalSerializer
    extend BaseSerializer
    def self.as_json (object)
      object.to_s
    end

    def self.from_loaded_json (json)
      BigDecimal.new(json)
    end
  end
end
