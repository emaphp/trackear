# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    return unless user.present?

    user_ability(user)
    project_ability(user)
    invoice_ability(user)
    activity_track_ability(user)
    expense_ability(user)

    can :manage, :all if user.is_admin?
  end

  def user_ability(user)
    can :update_locale, User, id: user.id
    can :update, User, id: user.id
  end

  def project_ability(user)
    can :create, Project
    can :read, Project, users: { id: user.id }
    can :manage, Project, project_contracts: { user: user, activity: 'Creator' }
    can :manage, ProjectContract
  end

  def invoice_ability(user)
    can :index, Invoice, user: user
    can :show, Invoice, user: user
    can :show, Invoice, is_client_visible: true, is_visible: true, project: {
      project_contracts: { user: user, activity: 'Client' }
    }
    can :download_invoice, Invoice, user: user
    can :download_payment, Invoice, user: user
    can :upload_invoice, Invoice, user: user

    # Allow to read the invoice status
    can :status, Invoice, user: user
    can :manage, Invoice, project: {
      project_contracts: { user: user, activity: 'Creator' }
    }
  end

  def activity_track_ability(user)
    can :manage, ActivityTrack, project_contract: { user: user }
    can :create, ActivityTrack
    can :manage, ActivityStopWatch
  end

  def expense_ability(user)
    # can :manage, Expense, user: user
  end
end
