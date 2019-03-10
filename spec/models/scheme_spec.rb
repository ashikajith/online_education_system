require 'spec_helper'

describe Scheme do 

	before(:all) do
		@subject = FactoryGirl.create(:subject)
	end	

	it "is a valid Scheme" do
		@scheme = FactoryGirl.create(:scheme, subject_ids: @subject.id)
	end

	it "is Invalid if name is nil" do
		@scheme = FactoryGirl.build(:scheme, subject_ids:@subject.id, name:nil).should_not be_valid
	end

	it "is Invalid if name is Not unique" do
		@scheme_1 = FactoryGirl.create(:scheme,subject_ids: @subject.id, name:"name3")
	  FactoryGirl.build(:scheme,subject_ids: @subject.id, name:"name3").should_not be_valid
	  @scheme_1.destroy
	end
	
	after(:all) do
		@subject.destroy
	end	
end