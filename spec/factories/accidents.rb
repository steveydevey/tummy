FactoryBot.define do
  factory :accident do
    occurred_at { "2025-12-02 02:00:10" }
    accident_type { "pee" }
    notes { "MyText" }
  end
end

