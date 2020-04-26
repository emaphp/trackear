# frozen_string_literal: true

class InvoiceMailer < ApplicationMailer
  default from: 'BlackMountain <contact@black-mountain.com.ar>'

  def invoice_notify(invoice)
    @invoice = invoice
    mail(
      to: 'BlackMountain <contact@black-mountain.com.ar>',
      subject: 'BlackMountain - Invoice ' + @invoice.from.strftime('%B %Y'),
      cc: ProjectService.clients_from_project(invoice.project).map(&:email)
    )
  end
end
