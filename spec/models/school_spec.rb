require 'spec_helper'

describe School do
	
	#ToDo Add test cases for format validation
	before(:all) do
	  @institution = FactoryGirl.create(:institution)
	end

  it "is a valid School" do
		@school = FactoryGirl.create(:school, institution_id:@institution.id)
	end

	it "should be invalid if institution_id is nil" do
		FactoryGirl.build(:school, institution_id: nil).should_not be_valid
	end

	it "should be invalid if name is nil" do
		FactoryGirl.build(:school, institution_id:@institution.id, name: nil).should_not be_valid
	end

	it "should be invalid if address is nil" do
		FactoryGirl.build(:school, institution_id:@institution.id, address: nil).should_not be_valid
	end

	it "should be invalid if city is nil" do
		FactoryGirl.build(:school, institution_id:@institution.id, city: nil).should_not be_valid
	end

	it "should be invalid if state is nil" do
		FactoryGirl.build(:school, institution_id:@institution.id, state: nil).should_not be_valid
	end

	it "should be invalid if country is nil" do
		FactoryGirl.build(:school, institution_id:@institution.id, country: nil).should_not be_valid
	end

	it "should be invalid if pincode is nil" do
		FactoryGirl.build(:school, institution_id:@institution.id, pincode: nil).should_not be_valid
	end

	it "should be invalid if  landline is nil" do
		FactoryGirl.build(:school, institution_id:@institution.id, landline: nil).should_not be_valid
	end
		
	it "should be invalid if mobile is nil" do
		FactoryGirl.build(:school, institution_id:@institution.id, mobile: nil).should_not be_valid
	end

	it "should be invalid if email is nil" do
		FactoryGirl.build(:school, institution_id:@institution.id, email: nil).should_not be_valid
	end

	it "should be invalid if website is nil" do
		FactoryGirl.build(:school, institution_id:@institution.id, website: nil).should_not be_valid
	end

	after(:all) do
		School.delete_all
		Institution.delete_all
	end
end
