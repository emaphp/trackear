class OtherSubmission < ApplicationRecord
  belongs_to :user

  validates :summary, presence: true
  validates :user_id, presence: true
  
  scope :submitted_in_period, ->(from, to) { where(created_at: from..to) }
end
