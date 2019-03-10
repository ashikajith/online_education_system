FactoryGirl.define do 
	factory :question_paper do
		name ('c'..'y').to_a.sample(6).join
		type ('k'..'z').to_a.sample(4).join
	end	
end