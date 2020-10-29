# frozen_string_literal: true

class ApplicationController < ActionController::Base
  layout :choose_layout

  before_action :set_raven_context
  before_action :add_home_breadcrumb

  after_action :user_activity

  around_action :user_time_zone, if: :user_signed_in?
  around_action :switch_locale

  private

  def user_activity
    current_user.try :touch
  end

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

  def user_time_zone(&block)
    Time.use_zone(current_user.time_zone, &block)
  end

  def choose_layout
    'application' unless user_signed_in?
    'authenticated' if user_signed_in?
  end

  def set_raven_context
    Raven.user_context(id: session[:current_user_id]) # or anything else in session
    Raven.extra_context(params: params.to_unsafe_h, url: request.url)
  end
end
