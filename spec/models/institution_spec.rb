require 'spec_helper'

describe Institution do
	# add cases for validation	
		
	it "is a valid unit" do
		@institution = FactoryGirl.create(:institution)
	end
	
	it "should be invalid if the name is nil" do
		FactoryGirl.build(:institution, name:nil).should_not be_valid
	end

	it "should be invalid if the address is nil" do
		FactoryGirl.build(:institution, address:nil).should_not be_valid
	end

	it "should be invalid if the area is nil" do
		FactoryGirl.build(:institution, area:nil).should_not be_valid
	end

	it "should be invalid if the city is nil" do
		FactoryGirl.build(:institution, city:nil).should_not be_valid
	end

	it "should be invalid if the state is nil" do
		FactoryGirl.build(:institution, state:nil).should_not be_valid
	end

	it "should be invalid if the country is nil" do
		FactoryGirl.build(:institution, country:nil).should_not be_valid
	end	

	it "should be invalid if the phone is nil" do
		FactoryGirl.build(:institution, phone:nil).should_not be_valid
	end

	it "should be invalid if the email is nil" do
		FactoryGirl.build(:institution, email:nil).should_not be_valid
	end

	describe 'email' do
		context "with a format" do
			it "should not accepts invalid emails" do
				@institution = FactoryGirl.create(:institution)
				@institution.email = "dkmdfkmas"
				@institution.should_not be_valid
			end
			it "should accpets valid emails" do
				@institution = FactoryGirl.create(:institution)
				@institution.email = "maikya@codingarena.in"
				@institution.should be_valid
			end	
		end
	end

	describe 'phone' do
		context "with a format" do
			it "should not accepts invalid characters" do
				@institution = FactoryGirl.create(:institution)
				@institution.phone = "dkmdfkmas"
				@institution.should_not be_valid
			end
			it "should not contain more than 10 digits" do
				@institution = FactoryGirl.create(:institution)
				@institution.phone = "12345678901234"
				@institution.should_not be_valid
			end
			it "should accepts if it has 10 digits" do
				@institution = FactoryGirl.create(:institution)
				@institution.phone = "1234567890"
				@institution.should be_valid
			end
		end
	end

	describe 'website' do
		context "with a valid website format" do
			it "should not accepts invalid url" do
				@institution = FactoryGirl.create(:institution)
				@institution.website = "dkmdfkmas,com"
				@institution.should_not be_valid
			end
			it "should accepts valid emails" do
				@institution = FactoryGirl.create(:institution)
				@institution.website = "http://www.facebook.com"
				@institution.should be_valid
			end	
		end
	end


	describe 'pincode' do
		context "with a valid pincode" do
			it "should not accepts characters" do
				@institution = FactoryGirl.create(:institution)
				@institution.website = "dkmdfkmaswd32r4com"
				@institution.should_not be_valid
			end
			it "should not accepts more than 6 digits" do
				@institution = FactoryGirl.create(:institution)
				@institution.website = "12134546789999876"
				@institution.should_not be_valid
			end	
			it "should accepts if the number of digits are 6" do
				@institution = FactoryGirl.create(:institution)
				@institution.pincode = "123456"
			end	
		end
	end

  after(:each) do
 		@institution.destroy	if @institution
  end	
end  