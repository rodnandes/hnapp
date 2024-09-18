class HomeController < ApplicationController
  def index
    update_stories
  end

  private

  def update_stories
    existing_stories = Story.pluck(:hn_id)
    new_stories = (fetch_story_ids.take(15) - existing_stories)
    return if new_stories.empty?

    new_stories_attrs = new_stories.map do |story_id|
      format_story_attributes(fetch_story(story_id))
    end

    Story.create!(new_stories_attrs)
  end

  def fetch_story_ids
    response_story_ids = Faraday.get('https://hacker-news.firebaseio.com/v0/topstories.json')
    JSON.parse(response_story_ids.body)
  end

  def fetch_story(story_id)
    response_story = Faraday.get("https://hacker-news.firebaseio.com/v0/item/#{story_id}.json")
    JSON.parse(response_story.body)
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
