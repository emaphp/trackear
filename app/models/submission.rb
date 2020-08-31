class Submission < ApplicationRecord
  belongs_to :user
  belongs_to :feedback_option

  validates :user_id, presence: true
  validates :feedback_option_id, presence: true

  scope :submitted_in_period, ->(from, to) { where(created_at: from..to) }
end
