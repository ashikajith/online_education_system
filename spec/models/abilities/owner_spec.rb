require 'spec_helper'
require "cancan/matchers"

describe "as an admin user" do
  before { @user = User.where(role:"owner").first }
  before { @ability = Ability.new(@user) }
  
  it "should be able to manage all" do
    @ability.should be_able_to(:manage, :all)
  end

end
