# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    if user_signed_in?
      @active_contracts = current_user.project_contracts.currently_active.includes(:project)
      @contracts = current_user.project_contracts.order(active_from: :desc).includes(:project)
      @invoices = current_user.invoices.includes(:project).order(from: :desc).limit(4)
    end
  end

  def me
    render json: current_user
  end

  def projects
    render json: current_user.projects
  end

  def active_contracts
    active_contracts = current_user.project_contracts.currently_active
    active_contracts_with_projects = active_contracts.includes(:project)
    render json: active_contracts_with_projects.to_json(include: :project)
  end

  def solutions; end
end
