require 'rails_helper'

RSpec.describe "/api/stories/:story_id/comments", type: :request do

  describe "GET #index" do
    it "renders a successful response" do
      get api_comments_url, as: :json
      expect(response).to be_successful
    end
  end

end
