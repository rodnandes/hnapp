class Comment < ApplicationRecord
  belongs_to :story
  belongs_to :parent, class_name: 'Comment', optional: true
  has_many :comments, class_name: 'Comment', foreign_key: 'parent_id'
  validates_presence_of :story

  attr_accessor :comment_hn_data, :comment_attrs

  def self.update_story_comments(story)
    hn_ids = story.story_hn_data['kids']&.map { |id| { hn_id: id } }
    story_comments = find_or_initialize_by(hn_ids)

    pp story_comments

    story.comments << story_comments

    story.comments.each do |comment|
      next if comment.time.present?

      comment.update_attributes_from_service
      comment.save! if comment.changed?
    end
  end

  def self.update_story_comments_later(story)
    HackerNewsCommentsFetcherJob.perform_later(story)
  end

  def update_attributes_from_service
    fetch_comment_data
    format_attributes
    assign_attributes(@comment_attrs)
  end

  private

  def fetch_comment_data
    puts "fetching comment #{hn_id} data (#{story.hn_id})..."
    @comment_hn_data = HackerNewsApi::Client.fetch_item(hn_id)
  end

  def format_attributes
    return if @comment_hn_data.nil?

    @comment_attrs = {
      by: @comment_hn_data["by"],
      time: Time.at(@comment_hn_data["time"]),
      text: @comment_hn_data["text"],
      hn_id: @comment_hn_data['id'],
      parent_id: parent_hn_id,
    }
  end

  def parent_hn_id
    if story.hn_id != @comment_hn_data["parent"]
      Comment.find_by(hn_id: @comment_hn_data["parent"])&.id
    end
  end
end
