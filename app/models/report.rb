class Report < ApplicationRecord
  belongs_to :invoice, optional: true
  belongs_to :user
  belongs_to :project

  has_many :report_worker_entries
  has_many :report_partner_entries

  accepts_nested_attributes_for :report_worker_entries, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :report_partner_entries, reject_if: :all_blank, allow_destroy: true
end
