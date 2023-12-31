class Nunes::Span < ApplicationRecord
  scope :by_recent, -> { order(created_at: :desc) }

  has_many :tags, class_name: "Nunes::Tag", dependent: :destroy

  def from_uid
    uri = URI::UID.parse(data)
    uri.decode
  end
end
