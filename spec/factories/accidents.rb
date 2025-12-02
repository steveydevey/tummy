FactoryBot.define do
  factory :accident do
    occurred_at { Time.current }
    accident_type { 'pee' }
    notes { 'Accident notes' }
  end
end

