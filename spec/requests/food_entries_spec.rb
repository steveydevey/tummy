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

  describe 'GET /food_entries/:id/edit' do
    let(:food_entry) { create(:food_entry) }

    it 'returns a successful response' do
      get edit_food_entry_path(food_entry)
      expect(response).to have_http_status(:success)
    end
  end

  describe 'PATCH /food_entries/:id' do
    let(:food_entry) { create(:food_entry, description: 'Original') }

    context 'with valid parameters' do
      let(:valid_params) do
        {
          food_entry: {
            description: 'Updated description',
            consumed_at: Time.current,
            notes: 'Updated notes'
          }
        }
      end

      it 'updates the food entry' do
        patch food_entry_path(food_entry), params: valid_params
        food_entry.reload
        expect(food_entry.description).to eq('Updated description')
        expect(food_entry.notes).to eq('Updated notes')
      end

      it 'redirects to the food entries index' do
        patch food_entry_path(food_entry), params: valid_params
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

      it 'does not update the food entry' do
        original_description = food_entry.description
        patch food_entry_path(food_entry), params: invalid_params
        food_entry.reload
        expect(food_entry.description).to eq(original_description)
      end

      it 'renders the edit template with errors' do
        patch food_entry_path(food_entry), params: invalid_params
        expect(response).to have_http_status(:unprocessable_content)
      end
    end
  end

  describe 'DELETE /food_entries/:id' do
    let!(:food_entry) { create(:food_entry) }

    it 'destroys the food entry' do
      expect {
        delete food_entry_path(food_entry)
      }.to change(FoodEntry, :count).by(-1)
    end

    it 'redirects to the food entries index' do
      delete food_entry_path(food_entry)
      expect(response).to redirect_to(food_entries_path)
    end
  end

  describe 'GET /timeline' do
    it 'returns a successful response' do
      get timeline_path
      expect(response).to have_http_status(:success)
    end

    it 'displays all entries in timeline' do
      food_entry = create(:food_entry, description: 'Meal', consumed_at: 1.day.ago)
      bowel_movement = create(:bowel_movement, occurred_at: 2.days.ago)
      accident = create(:accident, occurred_at: Time.current)

      get timeline_path
      expect(response.body).to include('Meal')
      expect(response.body).to include('FOOD')
      expect(response.body).to include('BM')
      expect(response.body).to include('ACCIDENT')
    end
  end

  describe 'GET / (root path with date filtering)' do
    it 'filters entries by date when date parameter is provided' do
      target_date = 2.days.ago.to_date
      food_entry_today = create(:food_entry, description: 'TodayEntry', consumed_at: Time.current)
      food_entry_target = create(:food_entry, description: 'TargetDateEntry', consumed_at: target_date.beginning_of_day + 12.hours)
      
      get root_path, params: { date: target_date.to_s }
      expect(response.body).to include('TargetDateEntry')
      expect(response.body).not_to include('TodayEntry')
    end

    it 'defaults to today when no date parameter' do
      food_entry_today = create(:food_entry, description: 'TodayEntry', consumed_at: Time.current)
      food_entry_yesterday = create(:food_entry, description: 'YesterdayEntry', consumed_at: 1.day.ago)
      
      get root_path
      expect(response.body).to include('TodayEntry')
    end

    it 'handles invalid date parameter gracefully' do
      get root_path, params: { date: 'invalid-date' }
      expect(response).to have_http_status(:success)
    end
  end

  describe 'date pre-population' do
    it 'pre-populates date when date parameter is provided' do
      target_date = 1.day.ago.to_date
      get new_food_entry_path, params: { date: target_date.to_s }
      expect(response).to have_http_status(:success)
    end
  end

  describe 'return_to parameter handling' do
    it 'redirects to return_to after create' do
      valid_params = {
        food_entry: {
          description: 'Test',
          consumed_at: Time.current
        },
        return_to: timeline_path
      }
      
      post food_entries_path, params: valid_params
      expect(response).to redirect_to(timeline_path)
    end

    it 'redirects to return_to after update' do
      food_entry = create(:food_entry)
      valid_params = {
        food_entry: {
          description: 'Updated',
          consumed_at: Time.current
        },
        return_to: timeline_path
      }
      
      patch food_entry_path(food_entry), params: valid_params
      expect(response).to redirect_to(timeline_path)
    end

    it 'redirects to return_to after destroy' do
      food_entry = create(:food_entry)
      delete food_entry_path(food_entry), params: { return_to: timeline_path }
      expect(response).to redirect_to(timeline_path)
    end
  end
end
