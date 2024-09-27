require 'faraday/typhoeus'

module HackerNewsApi
  class Client
    def get_top_stories_ids
      response = connection.get('/v0/topstories.json')

      JSON.parse(response.body)
    end

    def get_item(item_id)
      response = connection.get("/v0/item/#{item_id}.json")

      JSON.parse(response.body)
    end

    private

    def connection
      @connection ||= Faraday.new(url: "https://hacker-news.firebaseio.com") do |faraday|
        faraday.adapter :typhoeus
      end
    end
  end
end
