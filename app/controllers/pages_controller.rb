# frozen_string_literal: true

class PagesController < ApplicationController
  def robots
    respond_to :text
  end

  def sitemap
    respond_to :xml
  end
end
