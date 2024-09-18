require 'rails_helper'

RSpec.describe "Stories requests", type: :request do
  let!(:stories) { FactoryBot.create_list(:story, 5) }

  describe "GET /api/stories" do
    it "renders a successful response" do
      get api_stories_url, as: :json

      expect(response).to be_successful
    end
  end
end
