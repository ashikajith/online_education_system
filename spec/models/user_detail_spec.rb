require "spec_helper"

describe UserDetail do

	before(:all) do
		@institution = FactoryGirl.create(:institution)
		@user = FactoryGirl.build(:user, institution_id:@institution.id)
		@user_detail = FactoryGirl.create(:user_detail, user_id:@user.id)
	end		
	
	it "is a valid user_detail" do
		@user_detail_1 = FactoryGirl.build(:user_detail, user_id:@user.id)
		@user_detail_1.destroy
	end
	
	it "is invalid if the user_id is nil" do
		@user_detail_1 = FactoryGirl.create(:user_detail, user_id:nil).should_not be_valid
	end
	
	it "is invalid if the first name is nil" do
		@user_detail_1 = FactoryGirl.create(:user_detail, user_id:@user.id, first_name:nil).should_not be_valid
	end

	it "is invalid if the last name is nil" do
		@user_detail_1 = FactoryGirl.create(:user_detail, user_id:@user.id, last_name:nil).should_not be_valid
	end

	it "is invalid if the dob is nil" do
		@user_detail.dob = ""
		@user_detail.should_not be_valid
	end

	it "is invalid if the dob is greater than the present year" do
		@user_detail_1 = FactoryGirl.create(:user_detail, user_id:@user.id, dob:"2014-05-12").should_not be_valid
	end
	
	it "is invalid if the address is nil" do

		@user_detail.address = ""
		@user_detail.should_not be_valid
	end

	it "is invalid if the city is nil" do
		
		@user_detail.city = ""
		@user_detail.should_not be_valid
	end

	it "is invalid if the state is nil" do
		
		@user_detail.state = ""
		@user_detail.should_not be_valid
	end

	it "is invalid if the country is nil" do
		
		@user_detail.country = ""
		@user_detail.should_not be_valid
	end

	it "is invalid if the pincode is nil" do
		
		@user_detail.pincode = ""
		@user_detail.should_not be_valid
	end

	it "is invalid if the pincode contains characters" do
		
		@user_detail.pincode = "szxssssss"
		@user_detail.should_not be_valid
	end
	
	it "is invalid if the pincode contains more than 6 digits" do
	
		@user_detail.pincode = "123456789"
		@user_detail.should_not be_valid
	end
	
	it "is invalid if the mobile number contains characters" do
	
		@user_detail.mobile = "sacac22"
		@user_detail.should_not be_valid
	end
	
	it "is invalid if the mobile number contains more than 10 digits" do
	
		@user_detail.mobile = "12345678901245"
		@user_detail.should_not be_valid
	end		
	
	it "is invalid if the mobile number contains less than 10 numbers" do
	
		@user_detail.mobile = "12346"
		@user_detail.should_not be_valid
	end

	it "is invalid if the landline number contains characters " do
	
		@user_detail.landline = "csacasc"
		@user_detail.should_not be_valid
	end
	
	it "is invalid if the landline number contains less than 11 digits" do
	
		@user_detail.landline= "1234567"
		@user_detail.should_not be_valid
	end

	after(:all) do
		@institution.destroy
		@user.destroy
	end	
end