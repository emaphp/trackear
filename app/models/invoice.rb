# frozen_string_literal: true

class Invoice < ApplicationRecord
  belongs_to :project
  has_many :invoice_entries
  accepts_nested_attributes_for :invoice_entries

  validates :discount_percentage, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }

  after_create :create_invoice_entries_in_invoice_period

  scope :visible, -> { where(is_visible: true) }

  def calculate_subtotal
    invoice_entries.collect(&:calculate_total).sum
  end

  def calculate_total
    calculate_subtotal * ((100 - discount_percentage) / 100)
  end

  private

  def create_invoice_entries_in_invoice_period
    contracts = project.project_contracts
    contracts.each do |contract|
      logged = contract.activity_tracks.logged_in_period(from, to)
      logged.each do |activity|
        invoice_entries.create(
          rate: contract.project_rate,
          activity_track: activity,
          description: activity.description,
          from: activity.from,
          to: activity.to
        )
      end
    end
  end
end
