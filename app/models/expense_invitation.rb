class ExpenseInvitation < ApplicationRecord
  belongs_to :user

  before_create :set_status_to_pending
  after_create :send_email

  validates :name, presence: true
  validates :email, presence: true
  validates :email, uniqueness: { scope: :user_id }
  validate :check_self_invite

  def accept
    self.status = 'accepted'
  end

  private

  def check_self_invite
    errors.add(:email, "You can't invite yourself") if email == user.email
  end

  def set_status_to_pending
    self.token = SecureRandom.base58(24)
    self.status = 'pending'
  end

  def send_email
    ExpenseInvitationsMailer.invite(self).deliver
  end
end
