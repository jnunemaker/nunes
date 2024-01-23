# frozen_string_literal: true

module Nunes
  class Span < ApplicationRecord
    include Propertyable

    scope :by_recent, -> { order(created_at: :desc) }
    scope :roots, -> { where(span_parent_id: nil) }

    has_many :events, class_name: "Nunes::Event", dependent: :destroy

    belongs_to :parent, class_name: "Nunes::Span", foreign_key: :span_parent_id, optional: true
    has_many :children, class_name: "Nunes::Span", foreign_key: :span_parent_id, dependent: :destroy

    validates :name, presence: true
    validates :kind, presence: true
    validates :span_id, presence: true
    validates :trace_id, presence: true
    validates :start_timestamp, presence: true
    validates :end_timestamp, presence: true
  end
end
