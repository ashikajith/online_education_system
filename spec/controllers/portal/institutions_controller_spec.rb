require 'spec_helper'

describe Portal::InstitutionsController do
  describe ".When logged in as Owner" do
    before (:each) do
      @user = User.where(role:"owner").first
      sign_in @user
    end

    let(:institution) { mock_model(Institution) }

	  describe "GET 'index'" do
  		it "assigns all institutions" do
  			get :index
        assigns(:institutions)
      end
      it "renders the index template" do
        get :index
        response.should render_template :index
      end
      it "response should be be_success" do
        response.should be_success
      end
    end

    describe "GET #show" do
      let(:institution) { FactoryGirl.create(:institution) }
      it "find the institution" do
        get :show, id: institution
        assigns(:institution).should eq(institution)
      end
      it "renders the show template" do
        get :show, id: institution
        response.should render_template :show
      end
    end

    describe "GET #new" do
      it "assigns new institution" do
        get :new
        assigns(:institution)
      end
      it "renders new template" do
        get :new
        response.should render_template :new
      end
    end

    describe "POST #create" do
      let(:model_params) { double(:model_params) }
      before { Portal::InstitutionsController::InstitutionParams.stub(:build) { model_params } }
      before { Institution.stub(:new).and_return(institution) }
      it "saves the institution" do
        institution.should_receive(:save)
        institution_details =  FactoryGirl.attributes_for(:institution)
        post :create, institution: institution_details
      end
      context "when the institution is saved successfully" do
        before { institution.stub(:save).and_return(true) }
        it "sets a flash[:notice] message" do
          post :create
          flash[:notice].should_not be_nil
        end
        it "redirects to the institutions index" do
          post :create
          response.should redirect_to portal_institutions_path
        end
      end
      context "when the institution fails to save" do
        before { institution.stub(:save).and_return(false) }
        it "assigns @institution" do
          post :create
          assigns[:institution].should be_eql(institution)
        end
        it "re-renders the new template" do
          post :create
          response.should render_template("new")
        end
      end
    end

    describe "GET#edit" do
      before { Institution.stub(:find).and_return(institution) }
      it "assigns edit institution" do
        get :edit, id: institution.id
        assigns(:institution)
      end
      it "renders new template" do
        get :edit, id: institution.id
        response.should render_template :edit
      end
    end

    describe "PUT #update" do
      before { Institution.stub(:find).and_return(institution) }
      let(:model_params) { double(:model_params) }
      before { Portal::InstitutionsController::InstitutionParams.stub(:build) { model_params } }
      before { institution_details = FactoryGirl.attributes_for(:institution) }
      it "finds the institution" do
        institution.should_receive(:update).with(model_params).and_return(institution)
        put :update, id: institution.id, institution: institution
      end
      context "with valid attributes it updates institution and" do
        before { institution.stub(:update).and_return(true) }
        it "displays success message" do
          put :update, id: institution.id, institution: institution
          flash[:notice].should eq("Institution was successfully updated.")
        end
        it "and redirect_to index page" do
          put :update, id: institution.id, institution: institution
          response.should redirect_to portal_institutions_path
        end
      end
      context "invalid attributes" do
        before { institution.stub(:update).and_return(false) }
        it "error message must be displayed" do
          put :update, id: institution.id, institution: institution
          flash[:error].should_not be_nil
        end
        it "renders the edit form" do
          put :update, id: institution.id, institution: institution
          response.should render_template(:edit)
        end
      end
    end

    describe "DELETE#destroy" do
      before { Institution.stub(:find).and_return(institution) }
      context "success" do
        before { institution.stub(:destroy).and_return(true) }
        it "display success message" do
          delete :destroy, id: institution
          flash[:notice].should eq("Successfully Deleted...")
        end
        it "redirects to index" do
          delete :destroy, id: institution
          response.should redirect_to portal_institutions_path
        end
      end
      context "failure" do
        before { institution.stub(:destroy).and_return(false) }
        it "display error message" do
          delete :destroy, id: institution
          flash[:error].should_not be_nil
        end
        it "redirects to index" do
          delete :destroy, id: institution
          response.should redirect_to portal_institutions_path
        end
      end
    end

    after (:each) do
      sign_out @user
    end
  end
end
