require 'zerial/base_serializer'

module Zerial
  class CollectionSerializer
    include BaseSerializer
    attr_reader :element_serializer

    def initialize (element_serializer)
      @element_serializer = element_serializer
    end

    def as_json (collection)
      collection.map { |object|
        element_serializer.as_json(object)
      }
    end

    def from_loaded_json (json)
      json.map { |element|
        element_serializer.from_loaded_json(element)
      }
    end
  end
end
