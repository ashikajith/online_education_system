require 'spec_helper'

describe Portal::UsersController do

	describe "when logged in as Owner" do

		before(:each) do
			@user = User.where(role:"owner").first
			sign_in @user
		end

		let(:user) { mock_model(User) }

		describe "when user visits index" do
			it "list all the user list" do
				get :index
				assigns(:users)
			end
			it "renders the index template" do
				get :index
				response.should render_template :index
			end
			it "response should be_success" do
				response.should be_success
			end
		end

		describe "selecting a user" do
			before { @institution = FactoryGirl.create(:institution)}
			# let(:user) { FactoryGirl.create(:user, institution_id:@institution.id )}
			it "It finds the user" do
				get :show, id:@user
				assigns(:user).should eq(@user)
			end
			it "renders the show template" do
				get :show, id:@user
				assigns(:user).should render_template :show
			end
			# after { user.destroy }
		end

		describe "new user" do
			context "when atleast one institution is present" do
				before { FactoryGirl.create(:institution) }
				it "It creates a new user" do
					get :new
					assigns(:user)
				end
				it "assigns Institution" do
					get :new
					assigns(:institutions).should eq(Institution.all)
				end
				it "assigns schemes" do
					get :new
					assigns(:schemes).should eq(Scheme.all)
				end
				it "assigns School" do
					get :new
					assigns(:schools).should eq(School.all)
				end
				it " and renders the new template" do 
					get :new	
					response.should render_template :new
				end
			end
			context "when no institution is present" do
				before { Institution.delete_all }
				it "should display error message" do
					get :new
					flash[:error].should_not be_nil
				end
				it "should redirect to index page" do
					get :new
					response.should redirect_to portal_users_path
				end
			end
		end		

		describe "creating a new user" do
			let(:model_params) { double(:model_params) }
			before { Portal::UsersController::UserParams.stub(:build){ model_params } }
			before {User.stub(:new).and_return(user) }
			it "saves the user" do
				user_new = FactoryGirl.attributes_for(:user)
				user.should_receive(:save)
				user.should_receive(:build_user_detail)	
				post :create, user: user_new
			end
			context "with valid User name is entered " do
				before { user.stub(:save).and_return(true) }
				it "sets a flash[:notice] message" do
					post :create
					flash[:notice].should_not be_nil
				end
				it "redirect to the user index" do
					post :create	
					response.should redirect_to portal_users_path
				end
			end

			context "when the user fails to save" do
				before{ user.stub(:save).and_return(false) }
				before { user.stub(:build_user_detail).and_return(:user_detail) }
				it "assigns User" do
					post :create
					assigns(:user).should be_eql(user)
				end
				it "assigns institution" do
					post :create
					assigns(:institutions).should eq(Institution.all )
				end
				it "assigns schemes" do
					post :create
					assigns(:schemes).should eq(Scheme.all)
				end
				it "assigns School" do
					post :create
					assigns(:schools).should eq(School.all)
				end
				it "displays flash error" do
					post :create
					flash[:error].should_not be_nil
				end	
				it "re renders the new template" do
					post :create	
					response.should render_template :new
				end
			end
		end
		
		describe "edit a existing user" do
			before { User.stub(:find).and_return(user) }
			it "assigns edit user" do
				get :edit, id:user.id
				assigns(:user)
			end
			it "Assigns Institution" do
				get :edit, id:user.id
				assigns(:institutions).should eq(Institution.all)
			end
			it "assigns schemes" do
				get :edit, id: user.id
				assigns(:schemes).should eq(Scheme.all)
			end
			it "assigns School" do
				get :edit, id: user.id
				assigns(:schools).should eq(School.all)
			end
			it "render edit template"	do
				get :edit, id: user.id
				response.should render_template :edit
			end	
		end

		describe "update a user" do
			before { User.stub(:find).and_return(user) }
			let(:model_params) { double(:model_params) }
			before { Portal::UsersController::UserParams.stub(:build) {model_params} }
			before {user_details = FactoryGirl.attributes_for(:user) }
			it "finds the user" do
				user.should_receive(:update).and_return(user)
				put :update, id:user.id, user: user
			end
			context "with valid user_details" do
				before{ user.stub(:update).and_return(true) }
				it "displays success message" do
					put :update, id: user.id, user: user
					flash[:notice].should eq("User was Successfully updated")
				end
				it "redirects to index page" do
					put :update, id:user.id, user:user
					response.should redirect_to portal_users_path
				end
			end
			context "with invalid user_details" do
				before { user.stub(:update).and_return(false) }
				it "error message should be displayed" do
					put :update, id:user.id, user: user
					flash[:error].should_not be_nil
				end
				it "assigns Institution" do
				  put :update, id:user.id, user: user
				  assigns(:institutions).should eq(Institution.all)
				end
				it "assigns schemes" do
					put :update, id:user.id, user: user
					assigns(:schemes).should eq(Scheme.all)
				end
				it "assigns School" do
					put :update, id:user.id, user: user
					assigns(:schools).should eq(School.all)
				end
				it "renders the edit form" do
					put :update, id:user.id, user:user
					response.should render_template(:edit)
				end
			end
		end

		describe "delete a user" do
			before{ User.stub(:find).and_return(user) }
			context "success" do
				before { user.stub(:destroy).and_return(true) }
				it "displays success message" do
					delete :destroy, id:user
					flash[:notice].should eq("Successfully Deleted")
				end
				it "redirects to index" do
					delete :destroy, id:user
					response.should redirect_to portal_users_path
				end
			end
			context "failure" do
				before { user.stub(:destroy).and_return(false) }
				it "display error message" do
					delete :destroy, id:user
					flash[:error].should_not be_nil
				end
				it "redirects to index"	do
					delete :destroy, id:user
					response.should redirect_to portal_users_path
				end
			end
		end

		describe "when user visits their profile " do
			it "It finds the user" do
				get :profile, id:@user
				assigns(:user).should eq(@user)
			end
			it "renders the profile template" do
				get :profile, id:@user
				assigns(:user).should render_template :profile
			end
		end

		after (:each) do
			sign_out @user
		end	
	end
end