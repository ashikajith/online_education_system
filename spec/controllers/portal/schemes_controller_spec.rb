require 'spec_helper'

describe Portal::SchemesController do
	describe "When Logged in as Owner" do 
		before (:each) do 
			@user = User.where(role:"owner").first
			@subject = FactoryGirl.create(:subject)
			sign_in @user
		end
		
		let(:scheme) { mock_model(Scheme)} 

		describe "When user visits index"	do
			it "list all the schemes present in the table" do 
				get :index
				assigns(:schemes)
			end
			it "renders the index tempalte" do
				get :index	
				response.should render_template :index
			end
			it "response should be_success" do
				response.should be_success
			end	
		end

		describe "select a scheme" do
			let(:scheme) { FactoryGirl.create(:scheme, subject_ids:@subject.id) }
			it "It loads a corresponding scheme" do 
				get :show, id:scheme
				assigns(:scheme).should eq(scheme)
			end
			it "renders the show tempalte" do
				get :show, id:scheme	
				response.should render_template :show
			end
		end

		describe "new Scheme" do
			context "when atleast one subject is present" do
				it "it Creates a new Scheme" do 
					get :new
					assigns(:subject).should eq(Subject.all)
					assigns(:scheme)
				end
				it "renders new template" do	
					get :new
					response.should render_template :new
				end
			end

			context "When no subject is present" do
				before { Subject.delete_all }
        it "should display error message" do
          get :new
          flash[:error].should_not be_nil
        end
        it "and should redirect to the index page" do
          get :new
          response.should redirect_to portal_schemes_path
        end
			end
		end

		describe "creates a new scheme" do
			let(:model_params) { double(:model_params)}
			before { Portal::SchemesController::SchemeParams.stub(:build) {model_params } }
			before { Scheme.stub(:new).and_return(scheme) }
			it "saves the Scheme" do
        scheme_details =  FactoryGirl.attributes_for(:scheme)
        scheme.should_receive(:save)
        post :create, scheme: scheme_details
  		end
	  	context "with valid scheme name is entered" do
	  		before { scheme.stub(:save).and_return(true) } 
	  		it "sets a flash message" do
	  			post :create
	  			flash[:notice].should_not be_nil
	  		end
	  		it "redirects to the scheme index" do
	  			post :create
	  			response.should redirect_to portal_schemes_path
	  		end	
	  	end
	  	context "when the unit fails to save" do
	  		before{ scheme.stub(:save).and_return(false) }
	  		it "assigns Scheme" do
	  			post :create
	  			assigns(:scheme).should be_eql(scheme)
	  		end
	  		it "re renders the new template" do
	  			post :create	
	  			response.should render_template("new")
	  		end
	  	end		
	  end	

	  describe "edit a existing scheme" do
	  	before { Scheme.stub(:find).and_return(scheme) }
	  	it "assigns edit scheme" do
	  		get :edit, id:scheme.id
	  		assigns(:subject).should eq(Subject.all)
	  		assigns(:scheme)
	  	end
	  end

	  describe "update a scheme" do
	  	before { Scheme.stub(:find).and_return(scheme) }
	  	let(:model_params) { double(:model_params) }
	  	before { Portal::SchemesController::SchemeParams.stub(:build) { model_params} }
	  	before { scheme_details = FactoryGirl.attributes_for(:scheme) }
	  	it "find the requested scheme" do
	  		scheme.should_receive(:update).and_return(scheme)
	  		put :update, id: scheme.id, scheme:scheme
	  	end
	  	context "with valid scheme details" do
	  		before { scheme.stub(:update).and_return(true) }
		  	it "displays success message" do 
		  		put :update, id:scheme.id, scheme:scheme
		  		flash[:notice].should_not be_nil
		  	end
		  	it "redirects to index page after update" do 
		  		put :update, id:scheme.id, scheme:scheme
		  		response.should redirect_to portal_schemes_path
		  	end	
		  end
		  context "with invalid attributes" do
  			before { scheme.stub(:update).and_return(false) }
  			it "error message must be displayed" do
  				put :update, id: scheme.id, scheme:scheme
  				flash[:error].should_not be_nil
  			end
  			it "assigns the subjects to @subject" do
  			  put :update, id: scheme.id, scheme:scheme
  			  assigns(:subject).should eq(Subject.all)
  			end
  			it "renders the edit form" do
  				put :update, id: scheme.id, scheme:scheme
  				response.should render_template(:edit)
  			end
  		end
		end

		describe "delete a scheme" do
	  	before { Scheme.stub(:find).and_return(scheme) }
	  	context "success" do
	  		before { scheme.stub(:destroy).and_return(true) }
	  		it "display success message" do
	  			delete :destroy, id: scheme
	  			flash[:notice].should eq("Successfully Deleted")
	  		end
	  		it "redirects to index" do
	  			delete :destroy, id: scheme
	  			response.should redirect_to portal_schemes_path
	  		end
	  	end
	  	context "failure" do
	  		before{ scheme.stub(:destroy).and_return(false) }
	  		it "display error message" do
	  			delete :destroy, id: scheme
	  			flash[:error].should_not be_nil
	  		end
		  	it "redirects to index" do
		  		delete :destroy, id: scheme
		  		response.should redirect_to portal_schemes_path
		  	end
	  	end
	  end

		after (:each)	do
			sign_out @user
			@subject.destroy
	  end
	end				
end
