FactoryBot.define do
  factory :bowel_movement do
    occurred_at { Time.current }
    severity { 1 }
    notes { 'Normal movement' }
  end
end
