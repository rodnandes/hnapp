FactoryBot.define do
  factory :story do
    by { "MyString" }
    time { "2024-09-16 09:39:39" }
    text { "MyText" }
    url { "MyString" }
    score { 1 }
    title { "MyString" }
    comment_count { 1 }
    sequence(:hn_id) { |n| n }
  end
end
