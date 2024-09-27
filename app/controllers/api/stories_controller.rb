class Api::StoriesController < ApplicationController
  def index
    @stories = Story.limit(15)
  end

  def search
    query = params[:q]
    @stories = Story.api_search(query)
  end
end
