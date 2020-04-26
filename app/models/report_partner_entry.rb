# frozen_string_literal: true

class ReportPartnerEntry < ApplicationRecord
  belongs_to :report
  belongs_to :user
end
