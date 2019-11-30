# frozen_string_literal: true

class ActivityTrack < ApplicationRecord
  belongs_to :project_contract
  has_one :invoice_entry

  validates :description, presence: true
  validates :from, date: { before: :to }
  validates :to, date: { after: :from }
  validate :activity_is_inside_contract

  scope :logged_in_period, ->(from, to) { where(from: from..to) }

  def calculate_hours
    (to - from) / 1.hour
  end

  def calculate_user_amount
    calculate_hours * project_contract.user_rate
  end

  def activity_is_inside_contract
    unless project_contract.active_in?(from)
      errors.add(:from, 'is outside of the contract')
    end
    unless project_contract.active_in?(to)
      errors.add(:to, 'is outside of the contract')
    end
  end
end
