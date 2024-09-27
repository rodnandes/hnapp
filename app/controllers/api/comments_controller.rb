class Api::CommentsController < ApplicationController
  before_action :set_story

  def index
    if @story.comment_count != @story.comments.count
      Comment.find_or_create_comments(@story)
    end

    @comments = @story.comments
  end

  private

  def set_story
    @story = Story.includes(comments: :comments).find_by(hn_id: params[:story_id])
  end
end
