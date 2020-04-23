class Expense < ApplicationRecord
  include Shrine::Attachment(:receipt)
  monetize :price_cents

  belongs_to :project, optional: true

  scope :in_period, ->(from, to) { where(from: from..to) }

  def price_unit
    price * 100
  end
end
