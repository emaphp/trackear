# frozen_string_literal: true

class User < ApplicationRecord
  extend FriendlyId

  friendly_id :slug_candidates, use: :slugged

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         # :confirmable, :lockable,
         :trackable, :omniauthable, omniauth_providers: [:google_oauth2]

  has_many :project_contracts
  # has_many :project_invitations
  has_many :projects, through: :project_contracts

  has_many :activity_tracks
  has_many :activity_stop_watches

  has_many :invoices
  has_many :invoice_status

  has_many :expenses
  has_many :expense_invitations

  has_many :submissions

  def avatar_or_default
    picture || ''
  end

  def slug_candidates
    [%i[first_name last_name slug_suffix]]
  end

  def slug_suffix
    SecureRandom.hex(3)
  end

  def create_project_and_ensure_owner_contract(project_params)
    ActiveRecord::Base.transaction do
      project = Project.new(project_params)
      project_contracts.create!(
        activity: 'Creator',
        project: project,
        active_from: DateTime.now,
        ends_at: DateTime.now + 100.years,
        user_rate: 0,
        project_rate: 0
      )
      project.save!
      project
    end
  end

  def currently_active_contract_for(project)
    project_contracts.currently_active.find_by(project: project)
  end

  def self.by_email_or_create(email)
    User.where(email: email).first_or_create(
      email: email,
      password: Devise.friendly_token[0, 20]
    )
  end

  def self.from_omniauth(access_token)
    data = access_token.info
    user = User.where(email: data['email']).first_or_create(
      password: Devise.friendly_token[0, 20]
    )

    user.update(
      first_name: data['first_name'],
      last_name: data['last_name'],
      picture: data['image']
    )

    user
  end
end
