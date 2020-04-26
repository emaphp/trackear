# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'contact@black-mountain.com.ar'
  layout 'mailer'
end
