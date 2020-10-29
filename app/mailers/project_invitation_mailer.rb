class ProjectInvitationMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.project_invitation_mailer.invite.subject
  #
  def invite(invitation)
    @invitation = invitation
    mail(
      to: invitation.email,
      subject: "Te han invitado a #{invitation.project.name}"
    )
  end
end
