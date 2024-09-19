class HomeController < ApplicationController
  def index
    Story.fetch_from_service
  end

end
