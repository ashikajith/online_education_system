require 'spec_helper'

describe Portal::SubjectsController do

	describe "Unauthorized access" do
		context "when someone visits without loggin in" do
			it "should deny access and redirect to sign in page" do
   			get :index
   			response.should redirect_to(new_user_session_path)
   		end
		end
	end

  describe "When logged in as Owner" do
  	before (:each) do
			@user = User.where(role:"owner").first
    	sign_in @user
  	end

  	let(:subject) { mock_model(Subject)}

	  describe "GET 'index'" do
  		it "lists all the subjects" do
  			get :index
  			assigns(:subjects).should eq(Subject.all)
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
	  	let(:subject) { FactoryGirl.create(:subject) }
	  	it "it finds the subject" do
	  		get :show, id: subject
	  		assigns(:subject).should eq(subject)
	  	end
	  	it "renders the show template" do
	  		get :show, id: subject	
	  		response.should render_template :show
	  	end
	  end

	  describe "GET #new" do
	  	it "it creates a new subject" do
	  		get :new
	  		assigns(:subject)
	  	end
	  	it "renders new template" do
	  		get :new	
	  		response.should render_template :new
	  	end
	  end

	  describe "POST #create" do
	  	let(:model_params) { double(:model_params) }
	  	before { Portal::SubjectsController::SubjectParams.stub(:build) { model_params} }
	  	before { Subject.stub(:new).and_return(subject) }
	  	it "saves the subject" do
	  		subject.should_receive(:save)
	  		subject_details = FactoryGirl.attributes_for(:subject)
	  		post :create, subject: subject_details
	  	end	
	  	context "with valid subject name is entered" do
	  		before { subject.stub(:save).and_return(true) }
	  		it "sets a flash[:notice] message" do
	  	  	post :create
		  		flash[:notice].should_not be_nil
	  		end
	  		it "redirects to the Subject Index" do
	  			post :create
	  			response.should redirect_to portal_subjects_path
	  		end	
	  	end
	  	context "when the subject fails to save" do
	  		before { subject.stub(:save).and_return(false) }
	  		it "assigns subject" do
	  			post :create
	  			assigns(:subject).should be_eql(subject)
	  		end
	  		it "re renders the new template" do
	  			post :create	
	  			response.should render_template("new") 
	  		end
	  	end
	  end

	  describe "GET#edit" do
	  	before { Subject.stub(:find).and_return(subject) }
	  	it "assigns edit subject" do
	  		get :edit, id:subject.id
	  		assigns(:subject)
	  	end
	  end	

	  describe 'PUT #update' do
	  	before { Subject.stub(:find).and_return(subject) }
	  	let(:model_params) { double(:model_params) }
	  	before { Portal::SubjectsController::SubjectParams.stub(:build) {model_params} }
	  	before { subject_details = FactoryGirl.attributes_for(:subject) }
	  	it "finds the subject" do
	  		subject.should_receive(:update).and_return(subject)
	  		put :update, id: subject.id, subject: subject
	  	end
	  	context "with valid attributes it updates subject and" do
	  		before { subject.stub(:update).and_return(true) }
	  		it "displays success message" do
	  			put :update, id: subject.id, subject: subject
	  			flash[:notice].should eq("subject was successfully updated")
	  		end
	  		it "and redirect_to index page" do
	  			put :update, id: subject.id, subject: subject
	  			response.should redirect_to portal_subjects_path
	  		end
	  	end
	  	context "invalid attributes" do
	  		before { subject.stub(:update).and_return(false) }
	  		it "error message must be displayed" do
	  			put :update, id:subject.id, subject: subject
	  			flash[:error].should_not be_nil
	  		end
	  		it "renders the edit form" do
	  			put :update, id:subject.id, subject: subject
	  			response.should render_template(:edit)
	  		end	
	  	end	
	  end

	  describe "DELETE#destroy" do
	  	before { Subject.stub(:find).and_return(subject) }
	  	context "success" do
	  		before { subject.stub(:destroy).and_return(true) }
	  		it "display success message" do
	  			delete :destroy, id: subject
	  			flash[:notice].should eq("Successfully Deleted")
	  		end
	  		it "redirects to index" do
	  			delete :destroy, id: subject
	  			response.should redirect_to portal_subjects_path
	  		end
	  	end
	  	context "failure" do
	  		before{ subject.stub(:destroy).and_return(false) }
	  		it "display error message" do
	  			delete :destroy, id: subject
	  			flash[:error].should_not be_nil
	  		end
		  	it "redirects to index" do
		  		delete :destroy, id: subject
		  		response.should redirect_to portal_subjects_path
		  	end
	  	end
	  end	
 
	  after (:each) do
	  	sign_out @user
	  end
	end
end
