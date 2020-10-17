# frozen_string_literal: true

class InvoiceMailer < ApplicationMailer
  def invoice_notify(invoice)
    @invoice = invoice
    mail(
      to: '',
      subject: 'Trackear - Invoice ' + @invoice.from.strftime('%B %Y')
    )
  end
end
