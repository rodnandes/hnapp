class Comment < ApplicationRecord
  belongs_to :story
  belongs_to :parent, class_name: 'Comment', optional: true
  has_many :comments, class_name: 'Comment', foreign_key: 'parent_id'
  validates_presence_of :story

  attr_accessor :comment_hn_data, :comment_attrs

  def self.find_or_create_comments(story)
    new_comments = story.comments.where(parent_id: nil, time: nil)

    new_comments.each do |comment|
      comment.update_attributes_from_service
      comment.save! if comment.is_relevant
      comment.update_children
    end

    story.reload
  end

  def update_attributes_from_service
    fetch_comment_data
    format_attributes
    assign_attributes(@comment_attrs.merge(story_id: story.id))
  end

  def update_children
    hn_ids = comment_hn_data&.dig('kids')
    return if hn_ids.nil?

    hn_ids.each do |hn_id|
      comment = Comment.find_or_initialize_by(hn_id: hn_id, story_id: self.story.id)
      comment.update_attributes_from_service
      comment.save! if comment.is_relevant
      comment.update_children
    end
  end

  def is_relevant
    text.present? && text.split.size > 20
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
