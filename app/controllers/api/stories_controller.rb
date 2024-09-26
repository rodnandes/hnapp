class Api::StoriesController < ApplicationController
  def index
    @stories = Story.limit(15)
  end
end
