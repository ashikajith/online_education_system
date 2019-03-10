require 'spec_helper'

describe QuestionPaper do 

	before(:all) do
		@subject = FactoryGirl.create(:subject, name:"moon")
		@unit = FactoryGirl.create(:unit, subject_id:@subject.id)
	end

	before(:each) do
		# @question_paper = FactoryGirl.create(:question_paper,name:"cool" ,unit_id:@unit.id, subject_id:@subject.id)
	end	

	it "is a valid question" do
		# @question_paper1 = FactoryGirl.create(:question_paper, unit_id:@unit.id, subject_id:@subject.id)
		# @question_paper1.destroy
	end

	it "is invalid if the unit_id is nil" do
		@question_paper = FactoryGirl.build(:question_paper, unit_id:nil).should_not be_valid
		# @question_paper.destroy
	end

	it "is invalid if the subject_id is nil" do
		@question_paper = FactoryGirl.build(:question_paper, subject_id:nil).should_not be_valid
		# @question_paper.destroy
	end

	it "is invalid if the name is nil" do
		@question_paper = FactoryGirl.build(:question_paper, name:nil).should_not be_valid
		# @question_paper.destroy
	end

	it "is invalid if the type is nil" do
		@question_paper = FactoryGirl.build(:question_paper, type:nil).should_not be_valid
		# @question_paper.destroy
	end

	after(:all) do
		@subject.destroy
		@unit.destroy
	end	
end	