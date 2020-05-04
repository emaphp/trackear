# frozen_string_literal: true

class ActivityTrackService
  def self.all_from_range(project, user, from, to)
    user_contracts = project.project_contracts.where(user: user)
    tracks_from_user_contracts = ActivityTrack.where(project_contract: user_contracts)
    tracks_in_range = tracks_from_user_contracts.logged_in_period(from, to)
    tracks_in_range
  end
end
