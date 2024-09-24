class HackerNewsCommentsFetcherJob < ApplicationJob
  queue_as :default

  def perform(story, comments_hn_ids)
    story.update_comments_from_service(comments_hn_ids)
  end
end
