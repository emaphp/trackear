# frozen_string_literal: true

class MixpanelService
  def self.track(user, event, payload = {})
    tracker = Mixpanel::Tracker.new(Rails.application.credentials.mixpanel_token)
    tracker.track(user.id, event, payload)
  end
end
