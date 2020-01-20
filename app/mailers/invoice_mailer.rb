class InvoiceMailer < ApplicationMailer
    default from: "contact@black-mountain.com.ar"

    def invoice_notify(invoice)
        @invoice = invoice
        mail(to: "franco.montenegro.ruke@gmail.com", subject: "BlackMountain - Invoice " + @invoice.from.strftime('%B %Y'))
    end
end
