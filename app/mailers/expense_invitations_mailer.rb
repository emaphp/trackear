class ExpenseInvitationsMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.expense_invitations_mailer.invite.subject
  #
  def invite(expense_invitation)
    @expense_invitation = expense_invitation
    invitator = expense_invitation.user
    mail(
      to: expense_invitation.email,
      subject: "You have been invited to see #{invitator.first_name}'s expenses!"
    )
  end
end
