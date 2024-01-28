# frozen_string_literal: true

module Nunes
  class Event < ApplicationRecord
    include Propertyable

    belongs_to :span

    validates :name, presence: true
  end
end
