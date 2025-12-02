require 'rails_helper'

RSpec.describe "Accidents", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/accidents/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /new" do
    it "returns http success" do
      get "/accidents/new"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /create" do
    it "returns http success" do
      get "/accidents/create"
      expect(response).to have_http_status(:success)
    end
  end

end

