# frozen_string_literal: true

class InvoiceStatus < ApplicationRecord
  belongs_to :invoice_status, optional: true
  belongs_to :user
  belongs_to :invoice, optional: true
  has_many :invoice_statuses

  after_create :create_member_status, if: :admin_status?

  scope :with_news, -> { where('invoice_statuses.last_checked is null or invoice_statuses.last_checked < invoice_statuses.updated_at') }
  scope :for_members, -> { where('invoice_statuses.invoice_status_id is not null') }
  scope :in_process, -> { where.not(status: :user_complete).where.not(status: :admin_complete) }
  scope :for_project, lambda { |project|
    joins(invoice_status: [:invoice])
      .where({ invoice_status: { invoices: { project: project } } })
  }

  enum status: {
    admin_waiting_for_hours_confirmation: 'admin_waiting_for_hours_confirmation',
    admin_review_entries: 'admin_review_entries',
    admin_waiting_for_client_payment: 'admin_waiting_for_client_payment',
    admin_client_paid: 'admin_client_paid',
    admin_complete: 'admin_complete',

    user_confirm_hours: 'user_confirm_hours',
    user_waiting_for_client_payment: 'user_waiting_for_client_payment',
    user_client_paid: 'user_client_paid',
    user_paying_in_progress: 'user_paying_in_progress',
    user_complete: 'user_complete'
  }

  def is_completed?
    user_complete? || admin_complete?
  end

  def has_news?
    last_checked.nil? || last_checked < updated_at
  end

  def update_last_checked
    # update_columns wont run any callbacks
    # Do not use update, we don't want update_at to be updated as well
    update_columns(last_checked: DateTime.now)
  end

  def admin_complete_if_all_paid
    return unless all_paid?

    update(status: :admin_complete)
  end

  def member_add_payment
    update(status: :user_complete)
    invoice_status.admin_complete_if_all_paid
  end

  def admin_add_client_payment(exchange)
    members_in_process = invoice_statuses.in_process

    if members_in_process.count == 0
      update(status: :admin_complete)
      return
    end

    invoice_statuses.in_process.each do |member_status|
      member_status.invoice.exchange = exchange
      member_status.invoice.save

      member_status.status = :user_client_paid
      member_status.save
    end

    update(status: :admin_client_paid)
  end

  def user_add_invoice
    update(status: :user_paying_in_progress)
  end

  def admin_entries_added_to_client_invoice
    update(status: :admin_review_entries)
  end

  def admin_client_notification_sent
    invoice_statuses.in_process.each do |member_status|
      member_status.status = :user_waiting_for_client_payment
      member_status.save
    end
    update(status: :admin_waiting_for_client_payment)
  end

  def admin_status?
    invoice_status.nil?
  end

  def confirmed_hours?
    invoice.present?
  end

  def all_paid?
    !invoice_statuses.where.not(status: :user_complete).exists?
  end

  def all_hours_confirmed?
    !invoice_statuses.where(invoice: nil).exists?
  end

  def confirm_team_member_hours
    client_invoice = invoice_status.invoice
    invoice = user.invoices.new_team_member_invoice(client_invoice)

    self.invoice = invoice
    self.status = :user_waiting_for_client_payment
    save

    # Refactor, this code is fragile since
    # we have to make sure the invoice is saved
    # before being able to calculate its total
    self.status = :user_complete if invoice.calculate_total == 0
    save
  end

  private

  def create_member_status
    project = invoice.project
    contracts = project.project_contracts.currently_active.only_team.includes(:user)
    contracts.each do |contract|
      user = contract.user
      user_invoice_status = user.invoice_status.new
      user_invoice_status.invoice_status = self
      user_invoice_status.status = :user_confirm_hours
      user_invoice_status.save
    end
  end
end
