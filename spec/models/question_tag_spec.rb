require 'spec_helper'

describe QuestionTag do
  it "is a valid question tag" do
		FactoryGirl.create(:question_tag)
	end

	it "is invalid without a name" do
		FactoryGirl.build(:question_tag, name: nil).should_not be_valid
	end
	
	it "does not allow duplicate names case insensitive" do
		FactoryGirl.create(:question_tag)
		FactoryGirl.build(:question_tag,name:"random").should_not be_valid
	end

	after(:each) do
	  QuestionTag.delete_all
	end

end
