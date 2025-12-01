require 'rails_helper'

RSpec.describe "BowelMovements", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/bowel_movements/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /new" do
    it "returns http success" do
      get "/bowel_movements/new"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /create" do
    it "returns http success" do
      get "/bowel_movements/create"
      expect(response).to have_http_status(:success)
    end
  end

end
