# frozen_string_literal: true

class Expense < ApplicationRecord
  include Shrine::Attachment(:receipt)
  include Shrine::Attachment(:invoice)

  monetize :price_cents

  belongs_to :user
  belongs_to :project, optional: true

  scope :in_period, ->(from, to) { where(from: from..to) }

  default_scope { order(created_at: :desc) }

  validates :name, presence: true
  validates :from, presence: true
end
