# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Visitor Features' do
  feature 'Browse Tracks' do
    let!(:track_one) do
      create(:track, title: 'Track One', artist: 'Artist One', order_number: 1, length_in_seconds: 250)
    end
    let!(:track_two) do
      create(:track, title: 'Track Two', artist: 'Artist Two', order_number: 2, length_in_seconds: 300)
    end

    scenario 'Viewing the track index page content' do
      visit tracks_path

      aggregate_failures do
        expect(page).to have_css('h1', text: 'Playlist')
        within('table') do
          within('thead') do
            within('tr') do
              expect(page).to have_css('th', text: 'Number')
              expect(page).to have_css('th', text: 'Track')
              expect(page).to have_css('th', exact_text: '', count: 1)
            end
          end
          within('tbody') do
            expect(page).to have_css('tr', count: 2)

            within('tr:nth-child(1)') do
              expect(page).to have_css('td', text: track_one.order_number)
              expect(page).to have_css('td', text: track_one.title)
              expect(page).to have_link('show')
              expect(page).to have_link('edit')
              expect(page).to have_button('destroy')
            end

            within('tr:nth-child(2)') do
              expect(page).to have_css('td', text: track_two.order_number)
              expect(page).to have_css('td', text: track_two.title)
              expect(page).to have_link('show')
              expect(page).to have_link('edit')
              expect(page).to have_button('destroy')
            end
          end
        end
        expect(page).to have_link('Add Track')
      end
    end

    scenario 'Redirecting from the root page to the tracks page' do
      visit root_path

      expect(page).to have_current_path(tracks_path, ignore_query: true)
    end
  end

  feature 'View Track Details' do
    let!(:track_one) do
      create(:track, title: 'Track One', artist: 'Artist One', order_number: 1, length_in_seconds: 250)
    end

    scenario 'Viewing a track show page content' do
      visit track_path(track_one)

      aggregate_failures do
        expect(page).to have_css('h1', text: "##{track_one.order_number} #{track_one.title}")
        expect(page).to have_css('ul', count: 1)
        expect(page).to have_css('ul li', count: 2)
        expect(page).to have_css('li', text: "Artist: #{track_one.artist}")
        expect(page).to have_css('li', text: 'Length: 4:10')
        expect(page).to have_link('Back to Playlist')
      end
    end

    scenario 'Navigating to a track show page from the index page' do
      visit tracks_path

      click_on 'show', match: :first

      expect(page).to have_current_path(track_path(track_one), ignore_query: true)
    end

    scenario 'Navigating back to the track index page from the show page' do
      visit track_path(track_one)
      click_on 'Back to Playlist'

      expect(page).to have_current_path(tracks_path, ignore_query: true)
    end
  end

  feature 'Create New Track' do
    scenario 'Viewing the new track form page' do
      visit new_track_path

      aggregate_failures do
        expect(page).to have_css('h1', text: 'New Track')
        expect(page).to have_field('Order number')
        expect(page).to have_field('Title')
        expect(page).to have_field('Artist')
        expect(page).to have_field('Length in seconds')
        expect(page).to have_button('Create Track')
      end
    end

    scenario 'Creating a new track with valid details' do
      visit new_track_path

      fill_in 'Order number', with: 2
      fill_in 'Title', with: 'New Track'
      fill_in 'Artist', with: 'New Artist'
      fill_in 'Length in seconds', with: 200
      click_on 'Create Track'

      expect(Track.last).to have_attributes(order_number: 2, title: 'New Track', artist: 'New Artist',
                                            length_in_seconds: 200)
      expect(page).to have_current_path(tracks_path, ignore_query: true)
      expect(page).to have_css('.alert-success', text: 'New track successfully added!')
      expect(page).to have_css('tbody tr', count: 1)
    end

    scenario 'Creating a new track with invalid order number' do
      visit new_track_path

      fill_in 'Order number', with: 0
      fill_in 'Title', with: 'Invalid Track'
      fill_in 'Artist', with: 'New Artist'
      fill_in 'Length in seconds', with: 200
      click_on 'Create Track'

      expect(Track.count).to eq(0) # No new track should be created
      expect(page).to have_css('.alert-danger', text: 'Track creation failed.')
      expect(page).to have_content('Order number must be greater than 0', normalize_ws: true)
    end

    scenario 'Creating a new track with missing title', :js do
      visit new_track_path

      fill_in 'Order number', with: 2
      fill_in 'Artist', with: 'New Artist'
      fill_in 'Length in seconds', with: 200
      click_on 'Create Track'

      expect(Track.count).to eq(0) # No new track should be created
      message = page.find_by_id('track_title').native.attribute('validationMessage')
      expect(message).to eq 'Please fill out this field.'
    end

    scenario 'Creating a new track with invalid length' do
      visit new_track_path

      fill_in 'Order number', with: 2
      fill_in 'Title', with: 'New Track'
      fill_in 'Artist', with: 'New Artist'
      fill_in 'Length in seconds', with: 0
      click_on 'Create Track'

      expect(Track.count).to eq(0) # No new track should be created
      expect(page).to have_css('.alert-danger', text: 'Track creation failed.')
      expect(page).to have_content('Length in seconds must be greater than 0', normalize_ws: true)
    end

    scenario 'Navigating to the new track page from the index page' do
      visit tracks_path

      click_on 'Add Track'

      expect(page).to have_current_path(new_track_path, ignore_query: true)
    end

    scenario 'Navigating back to the track index page from the new page' do
      visit new_track_path

      click_on 'Cancel'

      expect(page).to have_current_path(tracks_path, ignore_query: true)
    end
  end

  feature 'Edit Track' do
    let!(:track) do
      create(:track, order_number: 1, title: 'Sample Track', artist: 'Sample Artist', length_in_seconds: 180)
    end

    scenario 'Viewing the edit track form page' do
      visit edit_track_path(track)

      aggregate_failures do
        expect(page).to have_css('h1', text: 'Edit Track')
        expect(page).to have_field('Order number', with: track.order_number)
        expect(page).to have_field('Title', with: track.title)
        expect(page).to have_field('Artist', with: track.artist)
        expect(page).to have_field('Length in seconds', with: track.length_in_seconds)
        expect(page).to have_button('Update Track')
      end
    end

    scenario 'Updating a track with valid details' do
      visit edit_track_path(track)

      fill_in 'Order number', with: 2
      fill_in 'Title', with: 'Updated Track'
      fill_in 'Artist', with: 'Updated Artist'
      fill_in 'Length in seconds', with: 200
      click_on 'Update Track'

      track.reload
      expect(track).to have_attributes(order_number: 2, title: 'Updated Track', artist: 'Updated Artist',
                                       length_in_seconds: 200)
      expect(page).to have_current_path(track_path(track), ignore_query: true)
      expect(page).to have_css('.alert-success', text: 'Track successfully updated!')
    end

    scenario 'Updating a track with invalid order number' do
      visit edit_track_path(track)

      fill_in 'Order number', with: 0
      click_on 'Update Track'

      track.reload
      expect(track.order_number).to eq(1) # Track should not be updated
      expect(page).to have_css('.alert-danger', text: 'Track update failed.')
      expect(page).to have_content('Order number must be greater than 0', normalize_ws: true)
    end

    scenario 'Updating a track with missing title', :js do
      visit edit_track_path(track)

      fill_in 'Title', with: ''
      click_on 'Update Track'

      track.reload
      expect(track.title).to eq('Sample Track') # Track should not be updated
      message = page.find_by_id('track_title').native.attribute('validationMessage')
      expect(message).to eq 'Please fill out this field.'
    end

    scenario 'Updating a track with invalid length' do
      visit edit_track_path(track)

      fill_in 'Length in seconds', with: 0
      click_on 'Update Track'

      track.reload
      expect(track.length_in_seconds).to eq(180) # Track should not be updated
      expect(page).to have_css('.alert-danger', text: 'Track update failed.')
      expect(page).to have_content('Length in seconds must be greater than 0', normalize_ws: true)
    end

    scenario 'Navigating to a track edit page from the index page' do
      visit tracks_path

      click_on 'edit', match: :first

      expect(page).to have_current_path(edit_track_path(track), ignore_query: true)
    end

    scenario 'Navigating back to the track index page from the edit page' do
      visit edit_track_path(track)

      click_on 'Cancel'

      expect(page).to have_current_path(tracks_path, ignore_query: true)
    end
  end

  feature 'Destroy Track' do
    let!(:track) { create(:track) }

    scenario 'Deleting a track from the index page' do
      visit tracks_path

      expect(page).to have_content(track.title)
      expect do
        click_on 'destroy', match: :first
      end.to change(Track, :count).by(-1)

      expect(page).to have_current_path(tracks_path, ignore_query: true)
      expect(page).to have_css('.alert-success', text: 'Track successfully removed')
      expect(page).to have_no_content(track.title)
    end
  end
end
