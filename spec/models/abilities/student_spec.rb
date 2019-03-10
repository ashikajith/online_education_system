require 'spec_helper'
require "cancan/matchers"

describe "as an institution admin" do
  before(:each) do
    @institution = FactoryGirl.create(:institution)
    @user = FactoryGirl.build(:user, institution_id: @institution.id)
    @ability = Ability.new(@user)
  end

  context "abilities for user" do
    it "should be able to mange only his profile" do
      @ability.should be_able_to(:manage, @user)
    end
  end

  context "ability for units" do
    it "can read all units" do
      @ability.should be_able_to(:read, Unit)
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
