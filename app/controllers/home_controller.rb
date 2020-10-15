# frozen_string_literal: true

class HomeController < ApplicationController
  before_action :authenticate_user!, only: [:settings]

  def index
    if user_signed_in?
      @active_contracts = current_user.project_contracts.currently_active.includes(:project)
      @contracts = current_user.project_contracts.order(active_from: :desc).includes(:project)
      @invoices = current_user.invoices.includes(:project).order(from: :desc).limit(4)
    end
  end

  def solutions; end

  def settings; end
end
