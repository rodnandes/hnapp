class Comment < ApplicationRecord
  belongs_to :story
  belongs_to :parent, class_name: 'Comment', optional: true
  has_many :comments, class_name: 'Comment', foreign_key: 'parent_id'

  scope :best, -> { reject { |c| c.text.blank? || c.text.split.size < 20 } }
end
