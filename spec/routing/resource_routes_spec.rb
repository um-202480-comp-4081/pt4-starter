# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Routes follow resource naming' do
  context 'when routing' do
    specify 'Tracks index' do
      expect(get: tracks_path).to route_to 'tracks#index'
    end

    specify 'Tracks show' do
      expect(get: track_path(1)).to route_to controller: 'tracks', action: 'show', id: '1'
    end

    specify 'Tracks new' do
      expect(get: new_track_path).to route_to 'tracks#new'
    end

    specify 'Tracks create' do
      expect(post: tracks_path).to route_to 'tracks#create'
    end

    specify 'Tracks edit' do
      expect(get: edit_track_path(1)).to route_to controller: 'tracks', action: 'edit', id: '1'
    end

    specify 'Tracks update' do
      expect(patch: track_path(1)).to route_to controller: 'tracks', action: 'update', id: '1'
    end

    specify 'Tracks destroy' do
      expect(delete: track_path(1)).to route_to controller: 'tracks', action: 'destroy', id: '1'
    end
  end

  context 'when creating path helpers' do
    specify 'tracks_path' do
      expect(tracks_path).to eq '/tracks'
    end

    specify 'track_path' do
      expect(track_path(1)).to eq '/tracks/1'
    end

    specify 'new_track_path' do
      expect(new_track_path).to eq '/tracks/new'
    end

    specify 'edit_track_path' do
      expect(edit_track_path(1)).to eq '/tracks/1/edit'
    end
  end
end
