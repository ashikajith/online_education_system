FactoryGirl.define do
  factory :subject do
    name ('b'..'y').to_a.sample(8).join
  end
end