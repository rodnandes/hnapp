json.extract! comment, :hn_id, :by, :time, :text, :id
json.comments comment.comments, partial: 'api/comments/comment', as: :comments
json.set! :text, strip_tags(comment.text)
