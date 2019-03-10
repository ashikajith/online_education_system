require 'spec_helper'

describe Knowledgebase do
  before(:each) do
    @subject = FactoryGirl.create(:subject)
    @unit = FactoryGirl.create(:unit, subject_id:@subject.id, days: '20', order:'4', name:'unit1')
    @user = User.first
  end

  it "is a valid entry" do
    @knowledgebase = FactoryGirl.create(:knowledgebase, unit_id:@unit.id, subject_id:@subject.id, user_id:@user.id)
  end

  it "is invalid if question is blank" do
    @knowledgebase_1 = FactoryGirl.build(:knowledgebase, question:'', unit_id:@unit.id, subject_id:@subject.id, user_id:@user.id).should_not be_valid
  end

  #TODO refactor test cases for unit_id and subject_id
  
  # it "is invalid if unit is nil" do
  #   @knowledgebase_1 = FactoryGirl.build(:knowledgebase, subject_id:@subject.id, user_id:@user.id).should_not be_valid
  # end

  # it "is invalid if subject is nil" do
  #   @knowledgebase_1 = FactoryGirl.build(:knowledgebase, unit_id:@unit.id, user_id:@user.id).should_not be_valid
  # end

  it "is invalid if user_id is nil" do
    @knowledgebase_1 = FactoryGirl.build(:knowledgebase, unit_id:@unit.id, subject_id:@subject.id, user_id:'').should_not be_valid
  end
end