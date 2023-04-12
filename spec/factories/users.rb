FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "Fulan #{n}" }
  end

  factory :tom, parent: :user do
    name { 'Tom' }
  end

  factory :jerry, parent: :user do
    name { 'Jerry' }
  end

  factory :bella, parent: :user do
    name { 'Bella' }
  end
end
