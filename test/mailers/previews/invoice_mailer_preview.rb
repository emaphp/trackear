# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/invoice_mailer
class InvoiceMailerPreview < ActionMailer::Preview
  def invoice_notify_preview
    InvoiceMailer.invoice_notify(Invoice.first)
  end
end
