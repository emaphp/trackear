class ExpenseInvitationService
    def self.get_list_from_user(user)
        ExpenseInvitation.where(email: user.email).where(status: 'accepted')
    end
end