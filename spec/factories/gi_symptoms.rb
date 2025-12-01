FactoryBot.define do
  factory :gi_symptom do
    symptom_type { 'Bowel Movement' }
    occurred_at { Time.current }
    severity { 5 }
    notes { 'Normal consistency' }
  end

  trait :bowel_movement do
    symptom_type { 'Bowel Movement' }
    severity { nil }
  end

  trait :nausea do
    symptom_type { 'Nausea' }
    severity { 7 }
  end

  trait :pain do
    symptom_type { 'Pain' }
    severity { 8 }
  end

  trait :bloating do
    symptom_type { 'Bloating' }
    severity { 6 }
  end
end
