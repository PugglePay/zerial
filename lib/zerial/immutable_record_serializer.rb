require 'zerial/base_serializer'

module Zerial
  class ImmutableRecordSerializer
    include BaseSerializer

    attr_reader :record_class, :serializers

    def initialize (record_class, serializers: {})
      @record_class = record_class
      @serializers = serializers
    end

    def as_json (object)
      record_class::ATTRIBUTES.reduce({}) do |attributes, attr|
        attributes.merge(
          attr.to_s => serializer_for_attribute(attr).as_json(
            object.public_send(attr)
          )
        )
      end
    end

    def from_loaded_json (json)
      record_class.new(
        record_class::ATTRIBUTES.reduce({}) { |attributes, attr|
          attributes.merge(
            attr => serializer_for_attribute(attr).from_loaded_json(
              json.fetch(attr.to_s)
            )
          )
        }
      )
    end

    private

    def serializer_for_attribute (attr)
      serializers.fetch(attr, DefaultSerializer)
    end
  end
end
