class ExpenseInvitation < ApplicationRecord
  belongs_to :user

  before_create :set_status_to_pending
  after_create :send_email

  def accept
    self.status = 'accepted'
  end

  private

  def set_status_to_pending
    self.token = SecureRandom.base58(24)
    self.status = 'pending'
  end

  def send_email
    ExpenseInvitationsMailer.invite(self).deliver
  end
end
