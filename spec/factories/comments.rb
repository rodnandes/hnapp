FactoryBot.define do
  factory :comment do
    by { "MyString" }
    time { "2024-09-16 09:38:12" }
    text { "MyText" }
    hn_id { 1 }
    story { nil }
  end
end
