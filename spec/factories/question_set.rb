FactoryGirl.define do 
	factory :question_set do
		name ('b'..'k').to_a.sample(10).join
	end	
end