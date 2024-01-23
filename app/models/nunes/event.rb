# frozen_string_literal: true

module Nunes
  class Event < ApplicationRecord
    include Propertyable

    belongs_to :span
    has_many :properties, class_name: "Nunes::Property", as: :owner, dependent: :destroy

    validates :name, presence: true
  end
end
