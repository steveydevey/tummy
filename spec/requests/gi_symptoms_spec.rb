require 'rails_helper'

RSpec.describe 'GISymptoms', type: :request do
  describe 'GET /gi_symptoms' do
    it 'returns a successful response' do
      get gi_symptoms_path
      expect(response).to have_http_status(:success)
    end

    it 'displays all GI symptoms' do
      symptom1 = create(:gi_symptom, symptom_type: 'Bowel Movement', occurred_at: 1.day.ago)
      symptom2 = create(:gi_symptom, symptom_type: 'Nausea', occurred_at: Time.current)

      get gi_symptoms_path
      expect(response.body).to include('Bowel Movement')
      expect(response.body).to include('Nausea')
    end
  end

  describe 'GET /gi_symptoms/new' do
    it 'returns a successful response' do
      get new_gi_symptom_path
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST /gi_symptoms' do
    context 'with valid parameters' do
      let(:valid_params) do
        {
          gi_symptom: {
            symptom_type: 'Bowel Movement',
            occurred_at: Time.current,
            severity: 5,
            notes: 'Normal'
          }
        }
      end

      it 'creates a new GI symptom' do
        expect {
          post gi_symptoms_path, params: valid_params
        }.to change(GiSymptom, :count).by(1)
      end

      it 'redirects to the food entries index' do
        post gi_symptoms_path, params: valid_params
        expect(response).to redirect_to(food_entries_path)
      end
    end

    context 'with invalid parameters' do
      let(:invalid_params) do
        {
          gi_symptom: {
            symptom_type: '',
            occurred_at: nil
          }
        }
      end

      it 'does not create a new GI symptom' do
        expect {
          post gi_symptoms_path, params: invalid_params
        }.not_to change(GiSymptom, :count)
      end

      it 'renders the new template with errors' do
        post gi_symptoms_path, params: invalid_params
        expect(response).to have_http_status(:unprocessable_content)
      end
    end
  end
end
