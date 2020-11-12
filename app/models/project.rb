# frozen_string_literal: true

class Project < ApplicationRecord
  include Shrine::Attachment(:icon)
  extend FriendlyId

  friendly_id :slug_candidates, use: :slugged

  has_many :project_invitations
  has_many :project_contracts
  has_many :users, through: :project_contracts

  has_many :invoices
  has_many :reports

  validates :name, presence: true

  def owners
    users.where "project_contracts.activity = ? or project_contracts.is_admin = ?", "Creator", true
  end

  def slug_candidates
    [%i[name slug_suffix]]
  end

  def slug_suffix
    SecureRandom.hex(3)
  end

  def from_owner(owner, props)
    owner_contract = owner.project_contracts.new(
      project: Project.new(props),
      activity: 'Creator',
      project_rate: 0,
      user_rate: 0,
      is_admin: true
    )
    owner_contract.project
  end

  def is_owner?(user)
    project_contracts.where(user: user).where("activity = ? or is_admin = ?", "Creator", true).any?
  end

  def is_client?(user)
    project_contracts.where(user: user, activity: 'Client').any?
  end
end
