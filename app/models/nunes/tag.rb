class Nunes::Tag < ApplicationRecord
  belongs_to :span

  validates :key, presence: true
  validates :value, presence: true
end
