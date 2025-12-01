require 'rails_helper'

RSpec.describe 'FoodEntries', type: :request do
  describe 'GET /food_entries' do
    it 'returns a successful response' do
      get food_entries_path
      expect(response).to have_http_status(:success)
    end

    it 'displays all food entries' do
      entry1 = create(:food_entry, description: 'Breakfast', consumed_at: 1.day.ago)
      entry2 = create(:food_entry, description: 'Lunch', consumed_at: Time.current)

      get food_entries_path
      expect(response.body).to include('Breakfast')
      expect(response.body).to include('Lunch')
    end
  end

  describe 'GET /food_entries/new' do
    it 'returns a successful response' do
      get new_food_entry_path
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST /food_entries' do
    context 'with valid parameters' do
      let(:valid_params) do
        {
          food_entry: {
            description: 'Dinner',
            consumed_at: Time.current,
            notes: 'Delicious meal'
          }
        }
      end

      it 'creates a new food entry' do
        expect {
          post food_entries_path, params: valid_params
        }.to change(FoodEntry, :count).by(1)
      end

      it 'redirects to the food entries index' do
        post food_entries_path, params: valid_params
        expect(response).to redirect_to(food_entries_path)
      end
    end

    context 'with invalid parameters' do
      let(:invalid_params) do
        {
          food_entry: {
            description: '',
            consumed_at: nil
          }
        }
      end

      it 'does not create a new food entry' do
        expect {
          post food_entries_path, params: invalid_params
        }.not_to change(FoodEntry, :count)
      end

      it 'renders the new template with errors' do
        post food_entries_path, params: invalid_params
        expect(response).to have_http_status(:unprocessable_content)
      end
    end
  end
end
