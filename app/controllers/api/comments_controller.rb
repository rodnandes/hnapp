class Api::CommentsController < ApplicationController
  before_action :set_story

  def index
    @comments = @story.comments
  end

  private

  def set_story
    @story = Story.find_by(hn_id: params[:story_id])
  end
end
