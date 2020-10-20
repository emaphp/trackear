# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'Trackear.app <contact@black-mountain.com.ar>'
  layout 'mailer'
end
