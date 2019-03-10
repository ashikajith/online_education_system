require 'spec_helper'

describe Unit do
	
	before(:all) do
		@subject = FactoryGirl.create(:subject)
	end
		
	it "is a valid unit" do
		@unit = FactoryGirl.create(:unit, subject_id:@subject.id)
		@unit.destroy
	end
	
	it "should be invalid if the subject_id is nil" do
		FactoryGirl.build(:unit, subject_id:nil).should_not be_valid
	end	

	it "should be invalid if the name is nil" do
		FactoryGirl.build(:unit, subject_id:@subject.id, name:nil).should_not be_valid
	end
	
	it "should be invalid if the day is nil" do
		FactoryGirl.build(:unit, subject_id:@subject.id, days:nil).should_not be_valid
	end
	
	it "should be invalid if the order is nil" do
		FactoryGirl.build(:unit, subject_id:@subject.id, order:nil).should_not be_valid
	end

	it "should be invalid if the days contains characters" do
		FactoryGirl.build(:unit, subject_id:@subject.id, days:"adas").should_not be_valid
	end
	
	it "should be invalid if the days contains more than 2 digits" do
		FactoryGirl.build(:unit, subject_id:@subject.id, days:"1023").should_not be_valid
	end
	
	it "should be invalid if the order contains characters" do
		FactoryGirl.build(:unit, subject_id:@subject.id, order:"dcsv").should_not be_valid
	end
	
	it "should be invalid if the name contains special characters" do
		FactoryGirl.build(:unit, subject_id:@subject.id, name:"!@#").should_not be_valid
	end

	it "should be invalid if the name is not unique" do
		@unit_1 = FactoryGirl.create(:unit, subject_id:@subject.id, name:"unique")
		FactoryGirl.build(:unit, subject_id:@subject.id, name:"unique").should_not be_valid
		@unit_1.destroy
	end	

	it "should be invalid if the order is not uniques with the subject_id" do
		@unit_1= FactoryGirl.create(:unit, order:"1", subject_id:@subject.id, name:"syllabus1")
		FactoryGirl.build(:unit, subject_id:@subject.id, order:"1", name:"syllabus2").should_not be_valid
		@unit_1.destroy
	end	
	
	after(:all) do 
		@subject.units.map { |e| e.destroy  }
		@subject.destroy
	end	
end
