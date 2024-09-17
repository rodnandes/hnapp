class HomeController < ApplicationController
  def index
    @stories = Story.includes(:comments).all
  end
end
