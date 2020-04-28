# frozen_string_literal: true

class ActivityTrack < ApplicationRecord
  belongs_to :project_contract
  has_one :invoice_entry

  validates :description, presence: true
  validates :from, date: { before: :to }
  validates :to, date: { after: :from }
  validate :activity_is_inside_contract

  scope :logged_in_period, ->(from, to) { where(from: from..to + 1.day) }

  def hours
    return "00:00" if !to || !from
    time_diff = (to - from)
    hours = (time_diff / 1.hour).floor
    dt = DateTime.strptime(time_diff.to_s, '%s')
    "#{hours}:#{dt.strftime "%M"}"
  end

  def hours=(hh_mm)
    s = hh_mm.split(":")
    h = s.empty? ? "00" : s[0]
    m = s.size != 2 ? "00" : s[1]
    self.to = from + h.to_i.hours + m.to_i.minutes
  end

  def calculate_hours
    (to - from) / 1.hour
  end

  def calculate_user_amount
    calculate_hours * project_contract.user_rate
  end

  def project_rate
    project_contract.project_rate
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
