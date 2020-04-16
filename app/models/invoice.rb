# frozen_string_literal: true

class Invoice < ApplicationRecord
  include Shrine::Attachment(:invoice)
  include Shrine::Attachment(:payment)

  belongs_to :project
  belongs_to :user
  has_many :invoice_entries
  accepts_nested_attributes_for :invoice_entries

  validates :discount_percentage, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }

  after_create :create_invoice_entries_in_invoice_period

  scope :for_client, -> { where(is_client_visible: true) }
  scope :for_client_visible, -> { where(is_visible: true).where(is_client_visible: true) }

  scope :in_range, ->(a, b) { where(['"invoices"."from" >= ? and "invoices"."to" >= ?', a, b]) }

  default_scope { order(created_at: :desc) }

  def calculate_subtotal
    invoice_entries.collect(&:calculate_total).sum
  end

  def calculate_total
    calculate_subtotal * ((100 - discount_percentage) / 100)
  end

  def calculate_hours
    invoice_entries.collect(&:calculate_quantity).sum
  end

  def calculate_revenue
    invoice_entries.collect(&:calculate_project_total).sum - calculate_total
  end

  def is_paid?
    payment.present?
  end

  def is_unpaid?
    !is_paid?
  end

  private

  def create_invoice_entries_in_invoice_period
    contracts = 
      if user.is_admin?
        project.project_contracts
      else
        project.project_contracts.where(user: user)
      end

    contracts.each do |contract|
      logged = contract.activity_tracks.logged_in_period(from, to)
      logged.each do |activity|
        invoice_entries.create(
          rate: user.is_admin ? contract.project_rate : contract.user_rate,
          activity_track: activity,
          description: activity.description,
          from: activity.from,
          to: activity.to
        )
      end
    end
  end
end
