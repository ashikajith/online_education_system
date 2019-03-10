require 'spec_helper'

describe Portal::KnowledgebaseController do
  describe "when logged in as a registered user" do
    before(:each) do
      @user = User.where(role:"owner").first
      sign_in @user
    end

    let(:knowledgebase) { mock_model(KnowledgeBase) }

    describe "visit index" do
      before {get :index}
      it "assigns latest knowledgebase question" do
        assigns(:latest)
      end
      it "assigns most rated knowledgebase questions" do
        assigns(:most_rated)
      end
      it "renders the index template" do
        response.should render_template :index
      end
      it "and response should success" do
        response.should be_success
      end
    end

    after(:each) do
      sign_out @user
    end
  end
end
