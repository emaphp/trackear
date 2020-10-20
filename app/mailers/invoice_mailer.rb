# frozen_string_literal: true

class InvoiceMailer < ApplicationMailer
  def invoice_notify(invoice)
    @invoice = invoice
    filename = "#{@invoice.from.strftime('%B %Y')}.pdf"
    invoice_pdf = ClientInvoicePdfService.build(invoice).render
    attachments[filename] = invoice_pdf
    mail(
      to: invoice.project.client_email,
      subject: "#{invoice.project.name} - #{@invoice.from.strftime('%B %Y')}"
    )
  end
end
