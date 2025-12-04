require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  controller do
    def index
      render plain: 'OK'
    end
  end

  describe '#set_timezone' do
    before do
      routes.draw { get 'index' => 'anonymous#index' }
    end

    it 'sets timezone from cookie' do
      cookies[:user_timezone] = 'America/New_York'
      get :index
      expect(Time.zone.name).to eq('America/New_York')
    end

    it 'falls back to TZ environment variable' do
      allow(ENV).to receive(:fetch).with('TZ', 'UTC').and_return('Europe/London')
      get :index
      expect(Time.zone.name).to eq('Europe/London')
    end

    it 'falls back to UTC if timezone is invalid' do
      allow(Time).to receive(:zone=).and_call_original
      allow(Time).to receive(:zone=).with('Invalid/Timezone').and_raise(TZInfo::InvalidTimezoneIdentifier)
      cookies[:user_timezone] = 'Invalid/Timezone'
      get :index
      expect(Time.zone.name).to eq('UTC')
    end
  end

  describe '#sanitize_return_to' do
    before do
      routes.draw { get 'index' => 'anonymous#index' }
    end

    it 'returns nil for blank URL' do
      expect(controller.send(:sanitize_return_to, '')).to be_nil
      expect(controller.send(:sanitize_return_to, nil)).to be_nil
    end

    it 'returns safe path for food_entries_path' do
      expect(controller.send(:sanitize_return_to, food_entries_path)).to eq(food_entries_path)
    end

    it 'returns safe path for root_path' do
      expect(controller.send(:sanitize_return_to, root_path)).to eq(root_path)
    end

    it 'returns nil for paths with IDs' do
      expect(controller.send(:sanitize_return_to, '/food_entries/123')).to be_nil
    end

    it 'returns nil for edit paths' do
      expect(controller.send(:sanitize_return_to, '/food_entries/123/edit')).to be_nil
    end

    it 'returns nil for new paths' do
      expect(controller.send(:sanitize_return_to, '/food_entries/new')).to be_nil
    end

    it 'preserves query parameters for safe paths' do
      result = controller.send(:sanitize_return_to, "#{root_path}?date=2025-01-01")
      expect(result).to eq("#{root_path}?date=2025-01-01")
    end

    it 'handles full URLs' do
      result = controller.send(:sanitize_return_to, "http://example.com#{root_path}")
      expect(result).to eq(root_path)
    end

    it 'returns nil for invalid URLs' do
      expect(controller.send(:sanitize_return_to, 'http://[invalid')).to be_nil
    end
  end
end

