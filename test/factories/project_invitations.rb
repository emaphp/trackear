FactoryBot.define do
  factory :project_invitation do
    email { "MyString" }
    token { "MyString" }
    user { nil }
    activity { "MyString" }
    project { nil }
    user_rate { "9.99" }
    status { "MyString" }
    token { "MyString" }
  end
end
