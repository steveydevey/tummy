require 'rails_helper'

RSpec.describe 'MiralaxCaps', type: :request do
  describe 'GET /miralax_caps' do
    it 'returns a successful response' do
      get miralax_caps_path
      expect(response).to have_http_status(:success)
    end

    it 'displays all miralax caps' do
      cap1 = create(:miralax_cap, amount: 1.0, occurred_at: 1.day.ago)
      cap2 = create(:miralax_cap, amount: 2.0, occurred_at: Time.current)

      get miralax_caps_path
      expect(response.body).to include('1 cap')
      expect(response.body).to include('2.0 caps')
    end
  end

  describe 'GET /miralax_caps/new' do
    it 'returns a successful response' do
      get new_miralax_cap_path
      expect(response).to have_http_status(:success)
    end

    it 'pre-populates date when date parameter is provided' do
      target_date = 1.day.ago.to_date
      get new_miralax_cap_path, params: { date: target_date.to_s }
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST /miralax_caps' do
    context 'with valid parameters' do
      let(:valid_params) do
        {
          miralax_cap: {
            occurred_at: Time.current,
            amount: 1.5,
            notes: 'Morning dose'
          }
        }
      end

      it 'creates a new miralax cap' do
        expect {
          post miralax_caps_path, params: valid_params
        }.to change(MiralaxCap, :count).by(1)
      end

      it 'redirects to the miralax caps index' do
        post miralax_caps_path, params: valid_params
        expect(response).to redirect_to(miralax_caps_path)
      end
    end

    context 'with invalid parameters' do
      let(:invalid_params) do
        {
          miralax_cap: {
            occurred_at: nil,
            amount: 3.0
          }
        }
      end

      it 'does not create a new miralax cap' do
        expect {
          post miralax_caps_path, params: invalid_params
        }.not_to change(MiralaxCap, :count)
      end

      it 'renders the new template with errors' do
        post miralax_caps_path, params: invalid_params
        expect(response).to have_http_status(:unprocessable_content)
      end
    end
  end

  describe 'GET /miralax_caps/:id/edit' do
    let(:miralax_cap) { create(:miralax_cap) }

    it 'returns a successful response' do
      get edit_miralax_cap_path(miralax_cap)
      expect(response).to have_http_status(:success)
    end
  end

  describe 'PATCH /miralax_caps/:id' do
    let(:miralax_cap) { create(:miralax_cap, amount: 1.0) }

    context 'with valid parameters' do
      let(:valid_params) do
        {
          miralax_cap: {
            occurred_at: Time.current,
            amount: 2.0,
            notes: 'Updated notes'
          }
        }
      end

      it 'updates the miralax cap' do
        patch miralax_cap_path(miralax_cap), params: valid_params
        miralax_cap.reload
        expect(miralax_cap.amount).to eq(2.0)
        expect(miralax_cap.notes).to eq('Updated notes')
      end

      it 'redirects to the miralax caps index' do
        patch miralax_cap_path(miralax_cap), params: valid_params
        expect(response).to redirect_to(miralax_caps_path)
      end
    end

    context 'with invalid parameters' do
      let(:invalid_params) do
        {
          miralax_cap: {
            occurred_at: nil,
            amount: 3.0
          }
        }
      end

      it 'does not update the miralax cap' do
        original_amount = miralax_cap.amount
        patch miralax_cap_path(miralax_cap), params: invalid_params
        miralax_cap.reload
        expect(miralax_cap.amount).to eq(original_amount)
      end

      it 'renders the edit template with errors' do
        patch miralax_cap_path(miralax_cap), params: invalid_params
        expect(response).to have_http_status(:unprocessable_content)
      end
    end
  end

  describe 'DELETE /miralax_caps/:id' do
    let!(:miralax_cap) { create(:miralax_cap) }

    it 'destroys the miralax cap' do
      expect {
        delete miralax_cap_path(miralax_cap)
      }.to change(MiralaxCap, :count).by(-1)
    end

    it 'redirects to the miralax caps index' do
      delete miralax_cap_path(miralax_cap)
      expect(response).to redirect_to(miralax_caps_path)
    end
  end
end

