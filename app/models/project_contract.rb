# frozen_string_literal: true

class ProjectContract < ApplicationRecord
  belongs_to :project
  belongs_to :user
  has_many :activity_tracks

  validates :project, presence: true
  validates :user, presence: true
  validates :activity, presence: true
  validates :active_from, date: { before: :ends_at }
  validates :ends_at, date: { after: :active_from }
  validates :project_rate, numericality: { greater_than_or_equal_to: :user_rate }
  validates :user_rate, numericality: { greater_than_or_equal_to: 0 }
  validate :dates_do_not_collide_with_existing_contracts

  scope :in_range, ->(from, to) { where(['active_from >= ? and ends_at >= ?', from, to]) }
  scope :active_in, ->(date) { where(['active_from <= ? and ends_at >= ?', date, date]) }
  scope :currently_active, -> { active_in(Date.today) }

  def dates_do_not_collide_with_existing_contracts
    return unless user.present?

    user_contracts = user.project_contracts.where(project: project).where.not(id: id)
    contracts_collide = user_contracts.active_in(active_from).or(user_contracts.active_in(ends_at))
    if contracts_collide.any?
      errors.add(:user_id, 'has contracts colliding with the selected dates')
    end
  end

  def active_in?(date)
    date.between?(active_from, ends_at)
  end

  def currently_active?
    today = Date.today
    active_in? today
  end

  def deferred?
    today = Date.today
    today < active_from
  end

  def finished?
    !currently_active? && !deferred?
  end
end
