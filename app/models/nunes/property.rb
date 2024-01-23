# frozen_string_literal: true

module Nunes
  class Property < ApplicationRecord
    PRIMITIVE_TYPE_MAP = {
      String => "string",
      Integer => "integer",
      Float => "float",
      TrueClass => "boolean",
      FalseClass => "boolean",
    }.freeze

    TYPE_MAP = {
      Array => "array",
    }.merge(PRIMITIVE_TYPE_MAP).freeze

    VALUE_TYPE_ERROR_MESSAGE = "must be primitive (#{PRIMITIVE_TYPE_MAP.values.uniq.sort.to_sentence}) or array of primitives".freeze

    enum :value_type, %i[string integer float boolean array], suffix: true

    validates :key, presence: true
    validate :type_check_value

    serialize :value, coder: JSON

    belongs_to :owner, polymorphic: true

    def value=(value)
      super.tap { set_value_type }
    end

    private

    def set_value_type
      self.value_type = TYPE_MAP[value.class]
    end

    def type_check_value
      if value.nil?
        errors.add(:value, "can't be blank")
        return
      end

      unless self.class.value_types.keys.include?(value_type)
        errors.add :value, VALUE_TYPE_ERROR_MESSAGE
        return
      end

      if value_type == "array" && !value.all? { |v| PRIMITIVE_TYPE_MAP.key?(v.class) }
        errors.add :value, VALUE_TYPE_ERROR_MESSAGE
      end
    end
  end
end
