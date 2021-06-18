require 'rails_helper'

RSpec.describe "PostsControllers", type: :request do
  describe "GET #index" do
    it "returns http success" do
      get '/posts'
      expect(response).to have_http_status(:ok)
    end
  end
end
