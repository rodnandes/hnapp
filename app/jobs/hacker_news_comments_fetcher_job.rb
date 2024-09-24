class HackerNewsCommentsFetcherJob < ApplicationJob
  queue_as :default

  def perform(story)
    Comment.update_story_comments(story)
  end
end
