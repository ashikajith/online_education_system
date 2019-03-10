require 'spec_helper'
require "cancan/matchers"

describe "as an institution admin" do
  before(:each) do
    @subject = FactoryGirl.create(:subject, name:"np")
    @institution = FactoryGirl.create(:institution)
    @user = FactoryGirl.build(:user, role:"mentor", institution_id: @institution.id, subject_id:@subject.id)
    @ability = Ability.new(@user)
  end

  context "abilities for user" do
    it "should be able to read  all users" do
      @ability.should be_able_to(:read, User)
    end
  end

  context "ability for units" do
    it "can manage all units" do
      @ability.should be_able_to(:manage, Unit)
    end
  end

  context "ability for Question" do
    it "can manage all Question" do
      @ability.should be_able_to(:manage, Question)
    end
  end

  context "ability for QuestionPapers" do
    it "can manage all QuestionPapers" do
      @ability.should be_able_to(:manage, QuestionPaper)
    end
  end

  context "ability for QuestionSets" do
    it "can manage all QuestionSets" do
      @ability.should be_able_to(:manage, QuestionSet)
    end
  end

  context "ability for QuestionTags" do
    it "can manage all QuestionTags" do
      @ability.should be_able_to(:manage, QuestionTag)
    end
  end

  context "ability for schemes" do
    it "can read schemes" do
      @ability.should be_able_to(:read, Scheme)
    end
  end
  
  after(:each) do
    @user.destroy
  end
end
