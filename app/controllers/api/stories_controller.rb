class Api::StoriesController < ApplicationController
  def index
    @stories = Story.includes(:comments).limit(15)
  end
end
