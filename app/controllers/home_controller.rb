class HomeController < ApplicationController
  def index
    update_stories
  end

  private

  def update_stories
    existing_stories = Story.pluck(:hn_id)
    new_stories = (top_15_stories_ids - existing_stories)
    return if new_stories.empty?

    new_stories_attrs = new_stories.map do |story_id|
      format_story_attributes(story_data(story_id))
    end

    Story.create!(new_stories_attrs)
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

  def top_15_stories_ids
    HackerNewsApi::Client.new.fetch_top_stories_ids.take(15)
  end
  def story_data(story_id)
    HackerNewsApi::Client.new.fetch_story(story_id)
  end
end
