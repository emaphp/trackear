# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    return unless user.present?

    can :create, Project
    can :read, Project, users: { id: user.id }
    can :manage, Project, project_contracts: { user_id: user.id, activity: 'Owner' }

    can :read, Invoice, project: { project_contracts: { user_id: user.id, activity: 'Owner' } }

    can :manage, ActivityTrack, project_contract: { user_id: user.id }
    can :create, ActivityTrack

    can :manage, :all if user.is_admin?
  end
end
