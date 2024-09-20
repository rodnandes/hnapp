class Story < ApplicationRecord
  has_many :comments
  default_scope { order(time: :desc) }

  accepts_nested_attributes_for :comments

  def self.fetch_from_service
    create_stories
  end

  private

  class << self
    def create_stories
      return if new_stories_hn_ids.empty?

      fetch_stories(new_stories_hn_ids).map do |story|
        story_attributes = format_story_attributes(story)
        new_story = create_with(story_attributes).find_or_create_by(hn_id: story_attributes[:hn_id])

        Comment.fetch_from_service(new_story, story['kids'])
      end
    end

    def new_stories_hn_ids
      top_15_stories_ids - pluck(:hn_id)
    end

    def top_15_stories_ids
      puts 'fetching stories ids...'
      HackerNewsApi::Client.new.fetch_top_stories_ids #.take(15)
    end

    def fetch_stories(stories_ids)
      stories_ids.map do |story_id|
        HackerNewsApi::Client.new.fetch_item(story_id)
      end
    end

    def format_story_attributes(story_data)
      {
        by: story_data['by'],
        time: Time.at(story_data['time']),
        text: story_data['text'],
        url: story_data['url'],
        score: story_data['score'],
        title: story_data['title'],
        comment_count: story_data['descendants'],
        hn_id: story_data['id'],
      }
    end
  end
end
