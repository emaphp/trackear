# Preview all emails at http://localhost:3000/rails/mailers/expense_invitations_mailer
class ExpenseInvitationsMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/expense_invitations_mailer/invite
  def invite
    ExpenseInvitationsMailer.invite(ExpenseInvitation.first)
  end

end
