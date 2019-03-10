require 'spec_helper'

describe Portal::QuestionSetsController do	
	describe "When Logged in as owner" do
		before(:each) do
			@user = User.where(role:"owner").first
			sign_in @user
		end

		let(:question_set) { mock_model(QuestionSet) }

		describe "when user visits index" do
			it "It should list all the question sets" do
				get :index
				assigns(:question_sets)
			end
			it "renders the index template" do
				get :index	
				response.should render_template :index
			end
			it "response should be_success" do
				response.should be_success
			end	
		end
		
		describe "selecting a question set" do 
			let(:question_set) { FactoryGirl.create(:question_set) }
			it "It should display the question set details" do
				get :show, id:question_set
				assigns(:question_set).should eq(question_set)
			end
			it "render the show template" do
				get :show, id:question_set	
				response.should render_template :show
			end
		end

		describe "new question paper" do
			it "should render the new form" do
				get :new
				assigns(:question_set)
			end
			it "renders a new template" do
				get :new	
				response.should render_template :new
			end
		end
		describe "create a question_set" do
			let(:model_params) { double(:model_params) }
			before { Portal::QuestionSetsController::QuestionSetParams.stub(:build) { model_params } }
			before { QuestionSet.stub(:new).and_return(question_set) }
			it "saves the question_set" do
				question_set_details = FactoryGirl.attributes_for(:question_set)
				question_set.should_receive(:save)
				post :create, question_set: question_set_details
			end	
			context "with valid question set details" do
				before { question_set.stub(:save).and_return(true) }
				it "sets a flash message" do
					post :create
					flash[:notice].should_not be_nil
				end
				it "redirects to the question_set index" do
					post :create
					response.should redirect_to portal_question_sets_path
				end
			end
			context "when question set fails to save" do
				before { question_set.stub(:save).and_return(false) }
				it "it assigns question_set" do
					post :create
					assigns(:question_set).should be_eql(question_set)
				end
				it "displays an error message" do
					post :create
					flash[:error].should_not be_nil
				end
				it "re renders the new template" do	
					post :create
					response.should render_template :new
				end
			end
		end

		describe "edit an existing question_set" do
			before { QuestionSet.stub(:find).and_return(question_set) }
			it "assigns edit question_set" do
				get :edit, id:question_set.id
				assigns(:question_set)
			end
		end

		describe "update a question_set" do
			before { QuestionSet.stub(:find).and_return(question_set) }
			let(:model_params) { double(:model_params) }
			before { Portal::QuestionSetsController::QuestionSetParams.stub(:build) { model_params } }
			before { question_set_details = FactoryGirl.attributes_for(:question_set) }
			it "It finds the question_set" do
				question_set.should_receive(:update).and_return(question_set)
				put :update, id:question_set.id, question_set: question_set
			end
			context "with valid question_set details" do
				before { question_set.stub(:update).and_return(true) }
				it "displays success message" do
					put :update, id:question_set.id, question_set:question_set
					flash[:notice].should eq("Question Set was successfully updated")
				end
				it "redirects to index page " do
					put :update, id:question_set.id, question_set:question_set
					response.should redirect_to portal_question_sets_path	
				end	
			end
			context "with invalid question_set details" do
				before { question_set.stub(:update).and_return(false) }
				it "displays the error message " do
					put :update, id:question_set.id, question_set: question_set
					flash[:error].should_not be_nil
				end
				it "assigns the question set" do
					put :update, id: question_set.id, question_set:question_set
					assigns(:question_set)
				end	
				it "renders the edit form" do
					put :update, id:question_set.id, question_set: question_set	
					response.should render_template :edit
				end
			end
		end
			
		describe "delete a question set" do
			before { QuestionSet.stub(:find).and_return(question_set) }
			context "success" do
				before { question_set.stub(:destroy).and_return(true) }
				it "displays success message" do
					delete :destroy, id: question_set
					flash[:notice].should eq("successfully deleted")
				end
  			it "redirects to question_set index" do
  				delete :destroy, id: question_set
  				response.should redirect_to portal_question_sets_path
  			end
  		end
  		context "failure" do
  			before{ question_set.stub(:destroy).and_return(false) }
  			it "displays error message" do
  				delete :destroy, id:question_set
  				flash[:error].should_not be_nil	
  			end
  			it "redirects to index page" do
  				delete :destroy, id: question_set	
  				response.should redirect_to portal_question_sets_path
  			end
  		end		
  	end

  	after (:each) do
	  	sign_out @user
	  end
	end	
end
