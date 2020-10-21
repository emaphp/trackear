class ProjectInvitation < ApplicationRecord
  belongs_to :user
  belongs_to :project

  before_create :set_pending

  scope :pending, -> { where(status: 'pending') }

  validates :email, presence: true
  validates :project, presence: true
  validates :user, presence: true
  validates :activity, presence: true
  validates :project_rate, numericality: { greater_than_or_equal_to: :user_rate }
  validates :user_rate, numericality: { greater_than_or_equal_to: 0 }

  def accept
    update(status: 'accepted')
    project.project_contracts.create(
      user: User.find_by(email: email),
      activity: activity,
      project_rate: project_rate,
      user_rate: user_rate,
      active_from: DateTime.now,
      ends_at: DateTime.now + 100.years
    )
  end

  def decline
    update(status: 'declined')
  end

  private

  def set_pending
    self.status = 'pending'
  end
end
