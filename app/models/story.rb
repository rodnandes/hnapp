class Story < ApplicationRecord
  has_many :comments, inverse_of: :story, dependent: :destroy
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
    assign_attributes(@story_attrs.merge!(story_comments_attributes))
    save!
  end

  private

  def story_comments_attributes
    return {} if @story_hn_data['kids'].nil?

    { comments_attributes: @story_hn_data['kids'].map { |id| { hn_id: id } } }
  end

  def self.prepare_stories_id
    hn_ids = new_top_stories_ids.map { |id| { hn_id: id } }
    upsert_all(hn_ids, unique_by: :hn_id)
  end

  def self.existing_stories_ids
    where.not(time: nil).pluck(:hn_id)
  end

  def self.new_top_stories_ids
    @top_stories_ids.take(15) - existing_stories_ids
  end

  def self.update_top_stories
    new_top_stories_ids.each do |story_id|
      story = Story.find_by(hn_id: story_id)
      return if story.nil? || !story.time.nil?

      story.update_from_service
    end
  end

  def self.fetch_new_top_stories_ids
    @hn_api ||= HackerNewsApi::Client.new
    @top_stories_ids = @hn_api.get_top_stories_ids
  end

  def fetch_story_data
    @hn_api ||= HackerNewsApi::Client.new
    @story_hn_data = @hn_api.get_item(hn_id)
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
