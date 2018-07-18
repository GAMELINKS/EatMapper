require "application_system_test_case"

class MapsTest < ApplicationSystemTestCase
  setup do
    @map = maps(:one)
  end

  test "visiting the index" do
    visit maps_url
    assert_selector "h1", text: "Maps"
  end

  test "creating a Map" do
    visit maps_url
    click_on "New Map"

    fill_in "About", with: @map.about
    fill_in "Date", with: @map.date
    fill_in "Image", with: @map.image
    fill_in "Latitude", with: @map.latitude
    fill_in "Longitude", with: @map.longitude
    fill_in "Title", with: @map.title
    click_on "Create Map"

    assert_text "Map was successfully created"
    click_on "Back"
  end

  test "updating a Map" do
    visit maps_url
    click_on "Edit", match: :first

    fill_in "About", with: @map.about
    fill_in "Date", with: @map.date
    fill_in "Image", with: @map.image
    fill_in "Latitude", with: @map.latitude
    fill_in "Longitude", with: @map.longitude
    fill_in "Title", with: @map.title
    click_on "Update Map"

    assert_text "Map was successfully updated"
    click_on "Back"
  end

  test "destroying a Map" do
    visit maps_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Map was successfully destroyed"
  end
end
