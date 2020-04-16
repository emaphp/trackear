# frozen_string_literal: true

class InvoiceEntry < ApplicationRecord
  belongs_to :invoice
  belongs_to :activity_track

  def calculate_quantity
    (to - from) / 1.hour
  end

  def calculate_total
    calculate_quantity * rate
  end

  def calculate_project_total
    calculate_quantity * activity_track.project_rate
  end
end
