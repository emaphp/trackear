# frozen_string_literal: true

class ExpenseReceiptService
  def self.download!(user, expense_id)
    expense = (
        user.expenses.find_by(id: expense_id) ||
        self.get_expense_from_invitation(user, expense_id)
      )
    receipt = expense.receipt
    metadata = receipt.metadata
    expense_from = expense.from.strftime('%B %Y')
    receipt_filename = metadata['filename']
    receipt_mime_type = metadata['mime_type']
    name = expense.name + ' ' + expense_from + ' - ' + receipt_filename
    receipt = expense.receipt.download.read
    { file: receipt, name: name, mime_type: receipt_mime_type }
  end

  private

  def self.get_expense_from_invitation(user, expense_id)
    expense = Expense.find_by(id: expense_id)
    accepted_invitations = expense.user.expense_invitations.accepted
    return expense if accepted_invitations.exists?(email: user.email)
  end
end
