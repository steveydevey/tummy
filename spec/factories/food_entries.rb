FactoryBot.define do
  factory :food_entry do
    description { 'Chicken and rice' }
    consumed_at { Time.current }
    notes { 'Tasted good' }
  end
end
