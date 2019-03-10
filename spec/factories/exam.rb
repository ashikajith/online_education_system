FactoryGirl.define do 
	factory :exam do
		start_time DateTime.now.to_s(:short)
	end	
end