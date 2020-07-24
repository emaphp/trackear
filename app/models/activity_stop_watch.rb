# frozen_string_literal: true

class ActivityStopWatch < ApplicationRecord
  has_one :activity_track
  belongs_to :user
  belongs_to :project
  # acts_as_paranoid

  scope :active, ->(project) { where(project: project).where(activity_track_id: nil) }

  def stop
    update(paused: true)
  end

  def resume
    update(paused: false)
  end

  def finish(contract)
    updated_end = DateTime.now
    track = contract.activity_tracks.create(
      from: start,
      to: updated_end,
      description: description.empty? ? 'Logged from stopwatch' : description
    )
    update(end: updated_end, activity_track_id: track.id)
  end
end
