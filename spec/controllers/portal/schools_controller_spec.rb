require 'spec_helper'

describe Portal::SchoolsController do

  describe "When logged in as Owner" do
  	before (:each) do
  		@user = User.where(role:"owner").first
    	sign_in @user
  	end

    let(:school) {  mock_model(School)}

	  describe "GET 'index'" do
	  	it "assigns schools to @schools" do
        get :index
        assigns(:schools)
      end
      it "and renders the index template" do
        get :index
        response.should render_template :index
      end
      it "and response should be success" do
        get :index
        response.should be_success
      end
	  end

	  describe "GET #show" do
      let(:institution) { FactoryGirl.create(:institution) }
      let(:school) { FactoryGirl.create(:school, institution_id: institution.id) }

	  	it "finds the school" do
        get :show, id: school
        assigns(:school).should eq(school)
      end
      it "and renders the show template" do
        get :show, id: school
        response.should render_template :show
      end
	  end

	  describe "GET #new" do
      context "when atleast one institution is present" do
        before { FactoryGirl.create(:institution) }
  	  	it "it assigns new school" do
  	  		get :new
  	  		assigns(:school)
  	  	end
        it "assigns institution" do
          get :new
          assigns(:institution).should eq(Institution.all)
        end
        it "and renders the new template" do
          get :new
          response.should render_template :new
        end
      end
      context "when no institution is registered" do
        it "should display error message" do
          Institution.delete_all
          get :new
          flash[:error].should_not be_nil
        end
        it "and should redirect to the index page" do
          get :new
          response.should redirect_to portal_schools_path
        end
      end
	  end

	  describe "POST #create" do
      let(:model_params) { double(:model_params) }
      before { Portal::SchoolsController::SchoolParams.stub(:build) { model_params } }
      before { School.stub(:new).and_return(school) }
      it "saves the school" do
        school_details =  FactoryGirl.attributes_for(:school)
        school.should_receive(:save)
        post :create, school: school_details
      end
      context "when the school is successfully saved" do
        before { school.stub(:save).and_return(true) }
        it "display success message as flash" do
          post :create
          flash[:notice].should_not be_nil
        end
        it "and should redirect to index page" do
          post :create
          response.should redirect_to portal_schools_path
        end
        context "when school fails to save" do
          before { school.stub(:save).and_return(false) }
          it "assigns @school" do
            post :create
            assigns[:school].should be_eql(school)
          end
          it "assigns institutions" do
            post :create
            assigns(:institution).should eq(Institution.all)
          end
          it "displays flash error" do
            post :create
            flash[:error].should_not be_nil
          end
          it "and render the new form" do
            post :create
            response.should render_template :new
          end
        end
      end
	  end

    describe "GET #edit" do
      before { School.stub(:find).and_return(school) }
      it "assigns edit school" do
        get :edit, id: school.id
        assigns(:school)
      end
      it "assigns institutions" do
        get :edit, id: school.id
        assigns(:institution).should eq(Institution.all)
      end
      it "renders edit template" do
        get :edit, id: school.id
        response.should render_template :edit
      end
    end

	  describe 'PUT update' do
	  	before { School.stub(:find).and_return(school) }
      let(:model_params){ double(:model_params) }
      before { Portal::SchoolsController::SchoolParams.stub(:build) {model_params} }
      it "finds the school" do
        school.should_receive(:update).and_return(school)
        put :update, id: school.id, school: school
      end
      context "with valid attributes it updates school and" do
        before { school.stub(:update).and_return(true) }
        it "displays success message" do
          put :update, id: school.id, school: school
          flash[:notice].should eq("School was successfully updated")
        end
        it "and redirect_to index page" do
          put :update, id: school.id, school: school
          response.should redirect_to portal_schools_path
        end
      end
      context "invalid attributes" do
        before { school.stub(:update).and_return(false) }
        it "displays error message and" do
          put :update, id: school.id, school: school
          flash[:error].should_not be_nil
        end
        it "renders the edit form" do
          put :update, id: school.id, school: school
          response.should render_template(:edit)
        end
      end
  	end

  	describe 'DELETE destroy' do
  		before { School.stub(:find).and_return(school) }
      context "success" do
        before { school.stub(:destroy).and_return(true) }
        it "display success message" do
          delete :destroy, id: school
          flash[:notice].should eq("Successfully Deleted...")
        end
        it "redirects to index" do
          delete :destroy, id: school
          response.should redirect_to portal_schools_path
        end
      end
      context "failure" do
        before { school.stub(:destroy).and_return(false) }
        it "display error message" do
          delete :destroy, id: school
          flash[:error].should_not be_nil
        end
        it "redirects to index" do
          delete :destroy, id: school
          response.should redirect_to portal_schools_path
        end
      end
  	end

		after (:each)	do
			sign_out @user
	  end
	end
end
