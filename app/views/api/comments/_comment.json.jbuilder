json.extract! comment, :hn_id, :by, :time, :text, :id, :parent_id
json.comments comment.comments, partial: 'api/comments/comment', as: :comment
json.set! :text, strip_tags(comment.text)
