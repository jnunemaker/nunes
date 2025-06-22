# frozen_string_literal: true

module Nunes
  class Span < ApplicationRecord
    include Propertyable

    MISSING_PARENT_ID = "0000000000000000"

    scope :by_recent, -> { order(created_at: :desc) }
    scope :roots, -> { where(parent_span_id: MISSING_PARENT_ID) }
    scope :requests, -> {
      roots.joins(:properties).where(kind: "server", properties: { key: "http.method" })
    }

    has_many :events, class_name: "Nunes::Event", dependent: :destroy

    belongs_to :parent, class_name: "Nunes::Span", foreign_key: :parent_span_id, optional: true
    has_many :children, class_name: "Nunes::Span", foreign_key: :parent_span_id, dependent: :destroy

    validates :name, presence: true
    validates :kind, presence: true
    validates :span_id, presence: true
    validates :trace_id, presence: true
    validates :start_timestamp, presence: true
    validates :end_timestamp, presence: true

    def root?
      parent_span_id == MISSING_PARENT_ID
    end

    def duration
      (end_timestamp - start_timestamp) / 1_000_000.0
    end
  end
end
