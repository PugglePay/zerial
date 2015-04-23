require 'zerial/base_serializer'

module Zerial
  module NilSerializer
    extend BaseSerializer
    def self.as_json (object)
      nil
    end

    def self.from_loaded_json (json)
      nil
    end
  end
end
