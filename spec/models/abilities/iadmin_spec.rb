require 'spec_helper'
require "cancan/matchers"

describe "as an institution admin" do
  before(:all) do
    @institution = FactoryGirl.create(:institution)
    @user = FactoryGirl.build(:user, email:"new_usr@codingarena.in", role:"iadmin", institution_id: @institution.id)
    @ability = Ability.new(@user)
  end

  context "abilities for institution" do
    it "should be able to read only his institution" do
      @ability.should be_able_to(:read, @user.institution)
    end

    it "should be able to edit only his institution" do
      @ability.should be_able_to(:edit, @user.institution)
    end

    it "should be able to update only his institution" do
      @ability.should be_able_to(:update, @user.institution)
    end
  end

  context "abilities for Schools" do
    it "should be able to manage only his institution's Schools" do
      @ability.should be_able_to(:manage, School, institution_id:@user.institution.id)
    end
  end

  context "ability for users" do
    it "can manage users under his institution" do
      @ability.should be_able_to(:manage, User, institution_id: @user.institution.id)
    end
  end

  context "ability for subjects" do
    it "can manage all subjects" do
      @ability.should be_able_to(:manage, Subject)
    end
  end

  context "ability for schemes" do
    it "can manage all schemes" do
      @ability.should be_able_to(:manage, Scheme)
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
  
  after(:all) do
    @user.destroy
  end
end
