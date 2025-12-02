require 'rails_helper'

RSpec.describe 'Accidents', type: :request do
  describe 'GET /accidents' do
    it 'returns a successful response' do
      get accidents_path
      expect(response).to have_http_status(:success)
    end

    it 'displays all accidents' do
      accident1 = create(:accident, occurred_at: 1.day.ago, accident_type: 'pee')
      accident2 = create(:accident, occurred_at: Time.current, accident_type: 'poop')

      get accidents_path
      expect(response.body).to include('Pee')
      expect(response.body).to include('Poop')
    end
  end

  describe 'GET /accidents/new' do
    it 'returns a successful response' do
      get new_accident_path
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST /accidents' do
    context 'with valid parameters' do
      let(:valid_params) do
        {
          accident: {
            occurred_at: Time.current,
            accident_type: 'both',
            notes: 'Accident notes'
          }
        }
      end

      it 'creates a new accident' do
        expect {
          post accidents_path, params: valid_params
        }.to change(Accident, :count).by(1)
      end

      it 'redirects to the accidents index' do
        post accidents_path, params: valid_params
        expect(response).to redirect_to(accidents_path)
      end
    end

    context 'with invalid parameters' do
      let(:invalid_params) do
        {
          accident: {
            occurred_at: nil,
            accident_type: 'invalid'
          }
        }
      end

      it 'does not create a new accident' do
        expect {
          post accidents_path, params: invalid_params
        }.not_to change(Accident, :count)
      end

      it 'renders the new template with errors' do
        post accidents_path, params: invalid_params
        expect(response).to have_http_status(:unprocessable_content)
      end
    end
  end

  describe 'GET /accidents/:id/edit' do
    let(:accident) { create(:accident) }

    it 'returns a successful response' do
      get edit_accident_path(accident)
      expect(response).to have_http_status(:success)
    end
  end

  describe 'PATCH /accidents/:id' do
    let(:accident) { create(:accident, accident_type: 'pee') }

    context 'with valid parameters' do
      let(:valid_params) do
        {
          accident: {
            occurred_at: Time.current,
            accident_type: 'poop',
            notes: 'Updated notes'
          }
        }
      end

      it 'updates the accident' do
        patch accident_path(accident), params: valid_params
        accident.reload
        expect(accident.accident_type).to eq('poop')
        expect(accident.notes).to eq('Updated notes')
      end

      it 'redirects to the accidents index' do
        patch accident_path(accident), params: valid_params
        expect(response).to redirect_to(accidents_path)
      end
    end

    context 'with invalid parameters' do
      let(:invalid_params) do
        {
          accident: {
            occurred_at: nil
          }
        }
      end

      it 'does not update the accident' do
        original_time = accident.occurred_at
        patch accident_path(accident), params: invalid_params
        accident.reload
        expect(accident.occurred_at).to eq(original_time)
      end

      it 'renders the edit template with errors' do
        patch accident_path(accident), params: invalid_params
        expect(response).to have_http_status(:unprocessable_content)
      end
    end
  end

  describe 'DELETE /accidents/:id' do
    let!(:accident) { create(:accident) }

    it 'destroys the accident' do
      expect {
        delete accident_path(accident)
      }.to change(Accident, :count).by(-1)
    end

    it 'redirects to the accidents index' do
      delete accident_path(accident)
      expect(response).to redirect_to(accidents_path)
    end
  end
end

