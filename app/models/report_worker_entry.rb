# frozen_string_literal: true

class ReportWorkerEntry < ApplicationRecord
  belongs_to :report
  belongs_to :user
  belongs_to :invoice, optional: true
end
