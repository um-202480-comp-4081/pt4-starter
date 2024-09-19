# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TracksController do
  describe 'GET #index' do
    it 'returns a success response' do
      get :index
      expect(response).to be_successful
    end

    it 'renders the index template' do
      get :index
      expect(response).to render_template(:index)
    end
  end

  describe 'GET #show' do
    let!(:track) { create(:track) }

    it 'returns a success response' do
      get :show, params: { id: track }
      expect(response).to be_successful
    end

    it 'renders the show template' do
      get :show, params: { id: track }
      expect(response).to render_template(:show)
    end
  end

  describe 'GET #new' do
    it 'returns a success response' do
      get :new
      expect(response).to be_successful
    end

    it 'renders the new template' do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe 'GET #edit' do
    let!(:track) { create(:track) }

    it 'returns a success response' do
      get :edit, params: { id: track }
      expect(response).to be_successful
    end

    it 'renders the edit template' do
      get :edit, params: { id: track }
      expect(response).to render_template(:edit)
    end
  end

  describe 'POST #create' do
    context 'with valid parameters' do
      it 'creates a new Track' do
        expect {
          post :create, params: { track: attributes_for(:track) }
        }.to change(Track, :count).by(1)
      end

      it 'redirects to the created track' do
        post :create, params: { track: attributes_for(:track) }
        expect(response).to redirect_to(tracks_url)
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new Track' do
        expect {
          post :create, params: { track: attributes_for(:track, title: nil) }
        }.not_to change(Track, :count)
      end

      it 're-renders the new template' do
        post :create, params: { track: attributes_for(:track, title: nil) }
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'PATCH #update' do
    let!(:track) { create(:track) }

    context 'with valid parameters' do
      it 'updates the requested track' do
        patch :update, params: { id: track, track: { title: 'New Title' } }
        track.reload
        expect(track.title).to eq('New Title')
      end

      it 'redirects to the track' do
        patch :update, params: { id: track, track: attributes_for(:track) }
        expect(response).to redirect_to(track)
      end
    end

    context 'with invalid parameters' do
      it 'does not update the track' do
        original_title = track.title
        patch :update, params: { id: track, track: { title: nil } }
        track.reload
        expect(track.title).to eq(original_title)
      end

      it 're-renders the edit template' do
        patch :update, params: { id: track, track: { title: nil } }
        expect(response).to render_template(:edit)
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:track) { create(:track) }

    it 'destroys the requested track' do
      expect {
        delete :destroy, params: { id: track }
      }.to change(Track, :count).by(-1)
    end

    it 'redirects to the tracks list' do
      delete :destroy, params: { id: track }
      expect(response).to redirect_to(tracks_url)
    end
  end
end
