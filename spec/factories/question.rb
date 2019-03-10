FactoryGirl.define do 
	factory :question do
		questions "My Question"
		option1 "1"
		option2 "2"
		option3 "3"
		option4 "4"
		option5 "5"
		explanation "bit complicated"
		correct_option "first one"
	end	
end