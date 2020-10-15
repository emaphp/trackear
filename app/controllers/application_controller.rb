# frozen_string_literal: true

class ApplicationController < ActionController::Base
  layout :choose_layout
  around_action :switch_locale
  before_action :add_home_breadcrumb

  private

  def add_home_breadcrumb
    add_breadcrumb t(:home), home_path
  end

  def switch_locale(&action)
    locale = if user_signed_in?
               current_user.locale || :es
             else
               :es
             end
    I18n.with_locale(locale, &action)
  end

  def choose_layout
    'application' unless user_signed_in?
    'authenticated' if user_signed_in?
  end
end
