# frozen_string_literal: true

module Nunes
  module Propertyable
    extend ActiveSupport::Concern

    included do
      has_many :properties, class_name: "Nunes::Property", as: :owner, dependent: :destroy
    end

    def property(key)
      properties_hash[key]
    end

    def properties_hash
      properties.each_with_object({}) do |property, hash|
        hash[property.key] = property.value
      end
    end
  end
end