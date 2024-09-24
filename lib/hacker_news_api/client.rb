module HackerNewsApi
  class Client
    def self.fetch_top_stories_ids
      parsed_body Faraday.get('https://hacker-news.firebaseio.com/v0/topstories.json')
    end

    def self.fetch_item(story_id)
      parsed_body Faraday.get("https://hacker-news.firebaseio.com/v0/item/#{story_id}.json")
    end

    private

    def self.parsed_body(response)
      JSON.parse response.body
    end
  end
end
