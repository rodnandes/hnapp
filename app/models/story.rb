class Story < ApplicationRecord
  has_many :comments, inverse_of: :story
  default_scope { order(time: :desc) }
  accepts_nested_attributes_for :comments, update_only: true

  attr_reader :story_hn_data, :story_attrs

  def self.create_top_stories
    fetch_new_top_stories_ids
    prepare_stories_id
    update_top_stories
  end

  def update_from_service
    fetch_story_data
    format_story_attributes
    assign_attributes(@story_attrs)
    save!
  end

  def update_comments_from_service
    HackerNewsCommentsFetcherJob.perform_later(self)
  end

  private

  def self.prepare_stories_id
    existing_stories_ids = Story.where.not(time: nil).limit(15).pluck(:hn_id)
    hn_ids = (@top_stories_ids - existing_stories_ids).map { |id| { hn_id: id } }
    transaction { find_or_create_by!(hn_ids) }
  end

  def self.update_top_stories
    @top_stories_ids.each do |story_id|
      story = Story.find_by(hn_id: story_id)
      return if story.nil?

      if story.time.nil?
        story.update_from_service
        story.update_comments_from_service
      end
    end
  end

  def self.fetch_new_top_stories_ids
    top_500_stories_ids = HackerNewsApi::Client.fetch_top_stories_ids
    @top_stories_ids = top_500_stories_ids.take(15)
  end

  def fetch_story_data
    @story_hn_data = HackerNewsApi::Client.fetch_item(hn_id)
  end

  def format_story_attributes
    @story_attrs = {
      by: @story_hn_data['by'],
      time: Time.at(@story_hn_data['time']),
      text: @story_hn_data['text'],
      url: @story_hn_data['url'],
      score: @story_hn_data['score'],
      title: @story_hn_data['title'],
      comment_count: @story_hn_data['descendants'],
      hn_id: @story_hn_data['id']
    }
  end
end
