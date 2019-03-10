FactoryGirl.define do
  factory :unit do
    name ('b'..'l').to_a.sample(6).join
    days (1..50).to_a.sample(1).join
    order (20..50).to_a.sample(1).join
  end
end