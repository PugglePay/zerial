require 'zerial/base_serializer'

module Zerial
  module MoneySerializer
    extend BaseSerializer
    def self.as_json (object)
      {
        "cents" => object.cents,
        "currency" => object.currency_as_string
      }
    end

    def self.from_loaded_json (json)
      Money.new(
        json.fetch("cents"), json.fetch("currency")
      )
    end
  end
end
