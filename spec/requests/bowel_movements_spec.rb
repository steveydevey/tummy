require 'rails_helper'

RSpec.describe 'BowelMovements', type: :request do
  describe 'GET /bowel_movements' do
    it 'returns a successful response' do
      get bowel_movements_path
      expect(response).to have_http_status(:success)
    end

    it 'displays all bowel movements' do
      movement1 = create(:bowel_movement, occurred_at: 1.day.ago, severity: 1)
      movement2 = create(:bowel_movement, occurred_at: Time.current, severity: 2)

      get bowel_movements_path
      expect(response.body).to include('1')
      expect(response.body).to include('2')
    end
  end

  describe 'GET /bowel_movements/new' do
    it 'returns a successful response' do
      get new_bowel_movement_path
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST /bowel_movements' do
    context 'with valid parameters' do
      let(:valid_params) do
        {
          bowel_movement: {
            occurred_at: Time.current,
            severity: 3,
            notes: 'Normal movement'
          }
        }
      end

      it 'creates a new bowel movement' do
        expect {
          post bowel_movements_path, params: valid_params
        }.to change(BowelMovement, :count).by(1)
      end

      it 'redirects to the bowel movements index' do
        post bowel_movements_path, params: valid_params
        expect(response).to redirect_to(bowel_movements_path)
      end
    end

    context 'with invalid parameters' do
      let(:invalid_params) do
        {
          bowel_movement: {
            occurred_at: nil,
            severity: 6
          }
        }
      end

      it 'does not create a new bowel movement' do
        expect {
          post bowel_movements_path, params: invalid_params
        }.not_to change(BowelMovement, :count)
      end

      it 'renders the new template with errors' do
        post bowel_movements_path, params: invalid_params
        expect(response).to have_http_status(:unprocessable_content)
      end
    end
  end

  describe 'GET /bowel_movements/:id/edit' do
    let(:bowel_movement) { create(:bowel_movement) }

    it 'returns a successful response' do
      get edit_bowel_movement_path(bowel_movement)
      expect(response).to have_http_status(:success)
    end
  end

  describe 'PATCH /bowel_movements/:id' do
    let(:bowel_movement) { create(:bowel_movement, severity: 1) }

    context 'with valid parameters' do
      let(:valid_params) do
        {
          bowel_movement: {
            occurred_at: Time.current,
            severity: 4,
            notes: 'Updated notes'
          }
        }
      end

      it 'updates the bowel movement' do
        patch bowel_movement_path(bowel_movement), params: valid_params
        bowel_movement.reload
        expect(bowel_movement.severity).to eq(4)
        expect(bowel_movement.notes).to eq('Updated notes')
      end

      it 'redirects to the bowel movements index' do
        patch bowel_movement_path(bowel_movement), params: valid_params
        expect(response).to redirect_to(bowel_movements_path)
      end
    end

    context 'with invalid parameters' do
      let(:invalid_params) do
        {
          bowel_movement: {
            occurred_at: nil
          }
        }
      end

      it 'does not update the bowel movement' do
        original_time = bowel_movement.occurred_at
        patch bowel_movement_path(bowel_movement), params: invalid_params
        bowel_movement.reload
        expect(bowel_movement.occurred_at).to eq(original_time)
      end

      it 'renders the edit template with errors' do
        patch bowel_movement_path(bowel_movement), params: invalid_params
        expect(response).to have_http_status(:unprocessable_content)
      end
    end
  end

  describe 'DELETE /bowel_movements/:id' do
    let!(:bowel_movement) { create(:bowel_movement) }

    it 'destroys the bowel movement' do
      expect {
        delete bowel_movement_path(bowel_movement)
      }.to change(BowelMovement, :count).by(-1)
    end

    it 'redirects to the bowel movements index' do
      delete bowel_movement_path(bowel_movement)
      expect(response).to redirect_to(bowel_movements_path)
    end
  end
end
