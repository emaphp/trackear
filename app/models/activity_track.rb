class ActivityTrack < ApplicationRecord
  belongs_to :project_contract
  has_one :invoice_entry

  validates :description, presence: true
  validates :from, date: { before: :to }
  validates :to, date: { after: :from }
  validate :activity_is_inside_contract

  scope :logged_in_period, -> (from, to) { where(:from => from..to) }

  def activity_is_inside_contract
    errors.add(:from, "is outside of the contract") unless project_contract.active_in?(from)
    errors.add(:to, "is outside of the contract") unless project_contract.active_in?(to)
  end
end
