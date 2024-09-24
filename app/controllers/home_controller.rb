class HomeController < ApplicationController
  def index
    Story.create_top_stories
  end

end
