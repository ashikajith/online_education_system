FactoryGirl.define do
  factory :scheme do
    name ('a'..'z').to_a.sample(4).join
  end
end