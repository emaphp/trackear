require "application_system_test_case"

class ActivityTracksTest < ApplicationSystemTestCase
  setup do
    @activity_track = activity_tracks(:one)
  end

  test "visiting the index" do
    visit activity_tracks_url
    assert_selector "h1", text: "Activity Tracks"
  end

  test "creating a Activity track" do
    visit activity_tracks_url
    click_on "New Activity Track"

    click_on "Create Activity track"

    assert_text "Activity track was successfully created"
    click_on "Back"
  end

  test "updating a Activity track" do
    visit activity_tracks_url
    click_on "Edit", match: :first

    click_on "Update Activity track"

    assert_text "Activity track was successfully updated"
    click_on "Back"
  end

  test "destroying a Activity track" do
    visit activity_tracks_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Activity track was successfully destroyed"
  end
end
