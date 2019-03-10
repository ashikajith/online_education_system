FactoryGirl.define do
	
	sequence :email do |n|
    "user#{n}@rubykitchen.in"
  end

	factory :user do
	  email 
	  password "mypassword"
	  password_confirmation "mypassword"
	  role "student"
	  before(:create) do |user|
	    user.skip_confirmation!
	  end
	end
end