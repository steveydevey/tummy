FactoryBot.define do
  factory :miralax_cap do
    occurred_at { Time.current }
    amount { 1.0 }
    notes { 'Miralax cap notes' }
  end
end

