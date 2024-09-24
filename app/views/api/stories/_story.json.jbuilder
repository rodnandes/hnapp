json.extract! story, :hn_id, :title, :by, :time, :comment_count, :url
json.comments story.comments, partial: 'api/comments/comment', as: :comment
