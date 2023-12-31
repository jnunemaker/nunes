class Nunes::Span < ApplicationRecord
  has_many :tags, class_name: "Nunes::Tag", dependent: :destroy
  belongs_to :parent, class_name: "Nunes::Span", optional: true
  has_many :children, class_name: "Nunes::Span", foreign_key: :parent_id, dependent: :destroy

  scope :root, -> { where(parent_id: nil) }
  scope :by_recent, -> { order(created_at: :desc) }
end
