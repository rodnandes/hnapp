class Comment < ApplicationRecord
  belongs_to :story
  belongs_to :parent, class_name: 'Comment', optional: true
  has_many :comments, class_name: 'Comment', foreign_key: 'parent_id'

  def self.fetch_from_service(story, kids_ids)
    create_story_comments(story, kids_ids)
  end

  class << self
    def create_story_comments(story, kids_ids)
      return unless kids_ids

      new_comments_ids(kids_ids).each do |kid_id|
        item = HackerNewsApi::Client.new.fetch_item(kid_id)
        if !item['text'].nil? && item['text'].split.size < 20
          create(format_comment_attributes(item).merge(story_id: story.id))
        end
        create_story_comments(story, item['kids'])
      end
    end

    def new_comments_ids(kids_ids)
      kids_ids - pluck(:hn_id)
    end

    def format_comment_attributes(comment)
      {
        by: comment["by"],
        time: Time.at(comment["time"]),
        text: comment["text"],
        hn_id: comment['id'],
        parent_id: find_by(hn_id: comment["parent"])&.id,
      }
    end
  end
end
