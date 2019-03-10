require 'spec_helper'

describe QuestionSet  do
	it "is a valid question set" do
	  @question_set = FactoryGirl.create(:question_set)
	end	

	it "is invalid question_set if the name is nil" do
		@question_set = FactoryGirl.build(:question_set, name:nil).should_not be_valid
	end
end