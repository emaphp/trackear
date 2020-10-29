# frozen_string_literal: true

class ClientInvoicePdfService
  def self.build(invoice)
    Receipts::Invoice.new(
      id: invoice.id,
      issue_date: invoice.created_at,
      due_date: invoice.created_at + 30.days,
      status: status(invoice),
      bill_to: [
        invoice.project.client_full_name,
        invoice.project.client_address,
        invoice.project.client_email,
      ],
      company: {
        name: invoice.user.company_name,
        address: invoice.user.company_address,
        email: invoice.user.company_email,
        logo: invoice.user.company_logo.present? ? invoice.user.company_logo.download : nil
      },
      line_items: [
        ["<b>Description</b>", "<b>Unit Cost</b>", "<b>Quantity</b>", "<b>Amount</b>"],
        *entries(invoice),
        [nil, nil, "Subtotal", invoice.calculate_subtotal.to_money.format({ symbol: true })],
        [nil, nil, "Total", invoice.calculate_total.to_money.format({ symbol: true })],
      ],
    )
  end

  private

  def self.status(invoice)
    return "<b><color rgb='#48BB78'>PAID</color></b>" if invoice.is_paid?
    return "<b><color rgb='#ECC94B'>PENDING</color></b>"
  end

  def self.entries(invoice)
    invoice.invoice_entries.map { |entry| [
      entry.description,
      entry.rate.to_money.format({ symbol: true }),
      entry.calculate_quantity.round(2),
      entry.calculate_total.to_money.format({ symbol: true })
    ] }
  end
end
