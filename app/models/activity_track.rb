# frozen_string_literal: true

class ActivityTrack < ApplicationRecord
  acts_as_paranoid

  belongs_to :project_contract
  has_one :invoice_entry

  validates :description, presence: true
  # validates :from, date: { before: :to }
  # validates :to, date: { after: :from }
  # validate :activity_is_inside_contract

  scope :logged_in_period, ->(from, to) { where(from: from.beginning_of_day..to.end_of_day) }

  after_create :set_rates_from_contract

  def set_rates_from_contract
    return unless project_contract.present?

    update(
      project_rate: project_contract.project_rate,
      user_rate: project_contract.user_rate
    )
  end

  def hours
    return '00:00' if !to || !from

    time_diff = (to - from)
    hours = (time_diff / 1.hour).floor
    dt = DateTime.strptime(time_diff.to_s, '%s')
    "#{hours}:#{dt.strftime '%M'}"
  end

  def hours=(hh_mm)
    s = hh_mm.split(':')
    h = s.empty? ? '00' : s[0]
    m = s.size != 2 ? '00' : s[1]
    self.to = from + h.to_i.hours + m.to_i.minutes
  end

  def calculate_hours
    (to - from) / 1.hour
  end

  def calculate_user_amount
    calculate_hours * safe_user_rate
  end

  def safe_user_rate
    return user_rate if user_rate.present?
    project_contract.user_rate
  end

  def safe_project_rate
    return project_rate if project_rate.present?
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
