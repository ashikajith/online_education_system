require 'spec_helper'

describe Question do 

	before(:all) do
		@subject = FactoryGirl.create(:subject, name:"moon")
		@unit = FactoryGirl.create(:unit, subject_id:@subject.id)
	end

	before(:each) do
		@question = FactoryGirl.create(:question, unit_id:@unit.id, subject_id:@subject.id)
	end	

	it "is a valid question" do
		@question1 = FactoryGirl.create(:question, unit_id:@unit.id, subject_id:@subject.id)
		@question1.destroy
	end

	it "is invalid if the unit_id is nil" do
		@question = FactoryGirl.build(:question, unit_id:nil).should_not be_valid
	end

	it "is invalid if the subject_id is nil" do
		@question = FactoryGirl.build(:question, subject_id:nil).should_not be_valid
	end	

	it "should be invalid if the questions is nil" do
		@question = FactoryGirl.build(:question, questions:nil).should_not be_valid
	end
	
	it "should be invalid if the first option is nil" do
		@question = FactoryGirl.build(:question, option1:nil).should_not be_valid
	end
	
	it "should be invalid if the second option is nil" do
		@question = FactoryGirl.build(:question, option2:nil).should_not be_valid
	end

	it "should be invalid if the third option is nil" do
		@question = FactoryGirl.build(:question, option3:nil).should_not be_valid
	end

	it "should be invalid if the fourth option is nil" do
		@question = FactoryGirl.build(:question, option4:nil).should_not be_valid
	end

	it "should be invalid if the fifth option is nil" do
		@question = FactoryGirl.build(:question, option5:nil).should_not be_valid
	end

	it "should be invalid if the explanation is nil" do
		@question = FactoryGirl.build(:question, explanation:nil).should_not be_valid
	end

	it "should be invalid if the correct option is nil" do
		@question = FactoryGirl.build(:question, correct_option:nil).should_not be_valid
	end

end
