# frozen_string_literal: true

class ApplicationController < ActionController::Base
  layout :choose_layout

  private

  def choose_layout
    'application' unless user_signed_in?
    'authenticated' if user_signed_in?
  end
end
