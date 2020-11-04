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
        [self.small("<b>Description</b>"), self.small("<b>Unit Cost</b>"), self.small("<b>Qty</b>"), self.small("<b>Amount</b>")],
        *entries(invoice),
        [nil, nil, self.small("<b>Subtotal</b>"), self.small(invoice.calculate_subtotal.to_money.format({ symbol: true }))],
        [nil, nil, self.small("<b>Total</b>"), self.small(invoice.calculate_total.to_money.format({ symbol: true }))],
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
      self.small(self.word_wrap(entry.description, line_width: 50)),
      self.small(entry.rate.to_money.format({ symbol: true })),
      self.small(entry.calculate_quantity.round(2)),
      self.small(entry.calculate_total.to_money.format({ symbol: true }))
    ] }
  end

  def self.word_wrap(text, line_width: 80, break_sequence: "\n")
    text.split("\n").collect! do |line|
      line.length > line_width ? line.gsub(/(.{1,#{line_width}})(\s+|$)/, "\\1#{break_sequence}").strip : line
    end * break_sequence
  end

  def self.small(text)
    "<font size='6px'>#{text}</font>"
  end
end
