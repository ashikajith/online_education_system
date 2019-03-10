require 'spec_helper'
require "cancan/matchers"

describe "as a school staff" do
  before(:each) do
    @institution = FactoryGirl.create(:institution)
    @school = FactoryGirl.create(:school, institution_id: @institution.id)
    @user = FactoryGirl.build(:user, role:"sstaff", institution_id: @institution.id, school_id: @school.id)
    @ability = Ability.new(@user)
  end

  context "abilities for school" do
    it "should be able to read only his school" do
      @ability.should be_able_to(:read, @user.school)
    end

    it "should be able to edit only his school" do
      @ability.should be_able_to(:edit, @user.school)
    end

    it "should be able to update only his school" do
      @ability.should be_able_to(:update, @user.school)
    end
  end

  context "ability for users" do
    it "can manage users under his school" do
      @ability.should be_able_to(:manage, User, school_id: @user.school_id)
    end
  end

  context "ability for units" do
    it "can read all units" do
      @ability.should be_able_to(:read, Unit)
    end
  end

  context "ability for scheme" do
    it "can read all scheme" do
      @ability.should be_able_to(:read, Scheme)
    end
  end

  after(:each) do
    @user.destroy
  end
end
