FactoryBot.define do
  factory :following do
    association :follower, factory: :tom
    association :followed, factory: :jerry

    approved

    trait :requested do
      status { :requested }
    end

    trait :approved do
      status { :approved }
    end
  end
end
