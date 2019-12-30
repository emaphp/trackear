# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    if user_signed_in?
      @active_contracts = current_user.project_contracts.currently_active.includes(:project)
      @contracts = current_user.project_contracts.order(active_from: :desc).includes(:project)
      @invoices = current_user.invoices.includes(:project).limit(5)
    else
      redirect_to new_user_session_path unless user_signed_in?
    end
  end
end
