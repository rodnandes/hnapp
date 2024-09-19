module HackerNewsApi
  class Client
    def fetch_top_stories_ids
      parsed_body Faraday.get('https://hacker-news.firebaseio.com/v0/topstories.json')
    end

    def fetch_item(story_id)
      parsed_body Faraday.get("https://hacker-news.firebaseio.com/v0/item/#{story_id}.json")
    end

    private

    def parsed_body(response)
      JSON.parse response.body
    end
  end
end
