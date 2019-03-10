require 'spec_helper'

describe Subject do

	it "is a valid subject" do
		FactoryGirl.create(:subject)
	end

	it "is invalid without a name" do
		FactoryGirl.build(:subject, name: nil).should_not be_valid
	end
	
	it "does not allow duplicate subject names case insensitive" do
		@subject = FactoryGirl.create(:subject,name: "Unique")
		FactoryGirl.build(:subject,name:"unique").should_not be_valid
	end

	after(:all) do
	  Subject.delete_all
	end
end
