require 'spec_helper'
require 'zerial'
require 'bigdecimal'
require 'money'
require 'immutable_record'

describe Zerial do
  before do
    Time.zone = "UTC"
  end

  def expect_correct_roundtrip (serializer, object)
    expect(
      serializer.from_json(serializer.to_json(object))
    ).to eq(object)
  end

  describe Zerial::DefaultSerializer do
    it "uses default as_json" do
      expect_correct_roundtrip(
        Zerial::DefaultSerializer,
        {"hello" => [1, "2"]}
      )
    end
  end

  describe Zerial::BigDecimalSerializer do
    it "works in a roundtrip" do
      expect_correct_roundtrip(
        Zerial::BigDecimalSerializer,
        BigDecimal.new("12.234")
      )
    end
  end

  describe Zerial::DateSerializer do
    it "works in a roundtrip" do
      expect_correct_roundtrip(
        Zerial::DateSerializer,
        Date.new(2013, 1 ,1)
      )
    end
  end

  describe Zerial::MoneySerializer do
    it "works in a roundtrip" do
      expect_correct_roundtrip(
        Zerial::MoneySerializer,
        Money.new(10_00, "SEK")
      )
    end
  end

  describe Zerial::NilSerializer do
    it "always returns nil when serializing and deserializing" do
      expect(Zerial::NilSerializer.to_json("hello")).to eq("null")
      expect(Zerial::NilSerializer.from_json('{"hello": 1}')).to be_nil
    end
  end

  describe Zerial::TimestampSerializer do
    it "works in a roundtrip" do
      expect_correct_roundtrip(
        Zerial::TimestampSerializer,
        Time.current.change(usec: 0)
      )
    end
  end

  describe Zerial::CollectionSerializer do
    it "serializes the elements of an array with a given serializer" do
      expect_correct_roundtrip(
        Zerial::CollectionSerializer.new(
          Zerial::BigDecimalSerializer
        ),
        [BigDecimal.new("10"), BigDecimal.new("0.11111")]
      )
    end
  end

  describe Zerial::ImmutableRecordSerializer do
    let(:record_class) {
      ImmutableRecord.new(:attr1, :attr2)
    }
    it "can serialize an ImmutableRecord" do
      expect_correct_roundtrip(
        Zerial::ImmutableRecordSerializer.new(record_class),
        record_class.new(attr1: "hello", attr2: 2)
      )
    end

    it "can accept specific serializers per attribute" do
      expect_correct_roundtrip(
        Zerial::ImmutableRecordSerializer.new(
          record_class,
          serializers: {
            attr1: Zerial::BigDecimalSerializer,
            attr2: Zerial::MoneySerializer
          }
        ),
        record_class.new(
          attr1: BigDecimal.new("10"),
          attr2: Money.new(10, "SEK")
        )
      )
    end

    it "works with deeply nested stuff" do
      expect_correct_roundtrip(
        Zerial::ImmutableRecordSerializer.new(
          record_class,
          serializers: {
            attr1: Zerial::CollectionSerializer.new(
              Zerial::ImmutableRecordSerializer.new(
                record_class,
                serializers: {
                  attr1: Zerial::MoneySerializer,
                  attr2: Zerial::TimestampSerializer
                }
              )
            ),
            attr2: Zerial::DateSerializer
          }
        ),
        record_class.new(
          attr1: [
            record_class.new(
              attr1: Money.new(10, "SEK"),
              attr2: Time.current.change(usec: 0)
            ),
            record_class.new(
              attr1: Money.new(20, "EUR"),
              attr2: 1.day.ago.change(usec: 0)
            ),
          ],
          attr2: Date.today
        )
      )
    end
  end

  describe Zerial::Maybe do
    context "in combination with CollectionSerializer" do
      it "only serializes non-nil values" do
        expect_correct_roundtrip(
          Zerial::CollectionSerializer.new(
            Zerial::Maybe.new(Zerial::BigDecimalSerializer)
          ),
          [nil, BigDecimal.new("10")]
        )
      end
    end

    context "in combination with ImmutableRecord" do
      let(:record_class) {
        ImmutableRecord.new(:attr1, :attr2)
      }
      let(:serializer) {
        Zerial::ImmutableRecordSerializer.new(
          record_class,
          serializers: {
            attr1: Zerial::Maybe.new(Zerial::TimestampSerializer),
            attr2: Zerial::Maybe.new(Zerial::MoneySerializer),
          }
        )
      }
      it "only serializes non-nil values" do
        expect_correct_roundtrip(
          serializer,
          record_class.new(
            attr1: nil,
            attr2: nil
          )
        )
        expect_correct_roundtrip(
          serializer,
          record_class.new(
            attr1: Time.current.change(usec: 0),
            attr2: Money.new(10, "SEK")
          )
        )
      end
    end
  end
end
