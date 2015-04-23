require 'zerial/base_serializer'

module Zerial
  module TimestampSerializer
    extend BaseSerializer
    def self.as_json (object)
      object.iso8601
    end

    def self.from_loaded_json (json)
      Time.zone.parse(json)
    end
  end
end
