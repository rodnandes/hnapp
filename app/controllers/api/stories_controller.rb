class Api::StoriesController < ApplicationController
  def index
    @stories = Story.includes(comments: :comments).limit(15)
  end
end
