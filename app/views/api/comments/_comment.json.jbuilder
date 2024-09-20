json.extract! comment, :hn_id, :by, :time, :text, :id, :parent_id
json.set! :text, strip_tags(comment.text)