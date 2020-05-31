# frozen_string_literal: true

class InvoiceService
  def self.invoices_from(user, project)
    if user.is_admin?
      project.invoices.includes(:user).order(from: :desc)
    elsif project.is_client? user
      project.invoices.includes(:user).for_client_visible.order(from: :desc)
    else
      user.invoices.includes(:user).where(project: project).order(from: :desc)
    end
  end
end
