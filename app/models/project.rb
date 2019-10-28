# frozen_string_literal: true

class Project < ApplicationRecord
  extend FriendlyId

  friendly_id :slug_candidates, use: :slugged

  include Shrine::Attachment(:icon)

  has_many :project_contracts
  has_many :users, through: :project_contracts

  has_many :invoices

  validates :name, presence: true
  validates :icon, presence: true

  def slug_candidates
    [%i[name slug_suffix]]
  end

  def slug_suffix
    SecureRandom.hex(3)
  end

  def from_owner(owner, props)
    owner_contract = owner.project_contracts.new(
      project: Project.new(props),
      activity: 'Owner',
      project_rate: 0,
      user_rate: 0
    )
    owner_contract.project
  end

  def is_client?(user)
    project_contracts.where(user: user, activity: 'Owner').any?
  end
end
