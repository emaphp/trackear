# frozen_string_literal: true

require 'test_helper'

class ActivityTracksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @activity_track = activity_tracks(:one)
  end

  test 'should get index' do
    get activity_tracks_url
    assert_response :success
  end

  test 'should get new' do
    get new_activity_track_url
    assert_response :success
  end

  test 'should create activity_track' do
    assert_difference('ActivityTrack.count') do
      post activity_tracks_url, params: { activity_track: {} }
    end

    assert_redirected_to activity_track_url(ActivityTrack.last)
  end

  test 'should show activity_track' do
    get activity_track_url(@activity_track)
    assert_response :success
  end

  test 'should get edit' do
    get edit_activity_track_url(@activity_track)
    assert_response :success
  end

  test 'should update activity_track' do
    patch activity_track_url(@activity_track), params: { activity_track: {} }
    assert_redirected_to activity_track_url(@activity_track)
  end

  test 'should destroy activity_track' do
    assert_difference('ActivityTrack.count', -1) do
      delete activity_track_url(@activity_track)
    end

    assert_redirected_to activity_tracks_url
  end
end
