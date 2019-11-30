# frozen_string_literal: true

module ProjectsHelper
  def calculate_hours_from(tracks)
    seconds_sum = tracks.reduce(0) { |seconds, track| seconds + distance_of_time_in_words_hash(track.from, track.to, accumulate_on: :seconds)[:seconds] }
    distance_of_time_in_words(Time.now, Time.now + seconds_sum, true, accumulate_on: :hours)
  end

  def calculate_invoice_amount_from(tracks)
    tracks.reduce(0) { |amount, track| amount + track.calculate_user_amount }
  end
end
