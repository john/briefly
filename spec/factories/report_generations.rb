FactoryBot.define do
  factory :report_generation do
    report_config { nil }
    content { "MyText" }
    status { "MyString" }
    error_message { "MyText" }
    generated_at { "2025-03-16 13:07:23" }
    sent_at { "2025-03-16 13:07:23" }
  end
end
