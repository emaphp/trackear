# frozen_string_literal: true

class ExpenseFileService
  def self.download_receipt!(user, expense_id)
    expense = (
      user.expenses.find_by(id: expense_id) ||
      get_expense_from_invitation(user, expense_id)
    )
    receipt = expense.receipt
    download!(expense, 'Receipt - ', receipt)
  end

  def self.download_invoice!(user, expense_id)
    expense = (
      user.expenses.find_by(id: expense_id) ||
      get_expense_from_invitation(user, expense_id)
    )
    invoice = expense.invoice
    download!(expense, 'Invoice - ', invoice)
  end

  private

  def self.download!(expense, file_name_prefix, file)
    metadata = file.metadata
    expense_from = expense.from.strftime('%B %Y')
    file_name = metadata['filename']
    file_mime_type = metadata['mime_type']
    name = file_name_prefix + expense.name + ' ' + expense_from + ' - ' + file_name
    { file: file.download.read, name: name, mime_type: file_mime_type }
  end

  def self.get_expense_from_invitation(user, expense_id)
    expense = Expense.find_by(id: expense_id)
    accepted_invitations = expense.user.expense_invitations.accepted
    return expense if accepted_invitations.exists?(email: user.email)
  end
end
