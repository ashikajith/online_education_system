require 'spec_helper'

describe Portal::QuestionsController do
	describe "when logged in as an owner" do

		before(:each) do
			@user = User.where(role:"owner").first
			sign_in @user
		end

		let(:question) {mock_model(Question) }
		
		describe "when User visits index " do
			it "It list all the questions of that unit in the subject" do
				get :index
			  assigns(:questions)
			end
			it "renders the index template" do
				get :index
				response.should render_template :index
			end
			it "response should be_success" do
				response.should be_success
			end		
		end
		
		describe "when user clicks show link'" do
			before { 
								@subject = FactoryGirl.create(:subject)
								@unit = FactoryGirl.create(:unit, subject_id:@subject.id) 
							}
			let(:question) { FactoryGirl.create(:question, subject_id:@subject.id, unit_id:@unit.id)}
			it "It find question " do
				get :show, id:question
				assigns(:question).should eq(question)
			end
			it "renders the show template" do
				get :show, id:question
				response.should render_template :show
			end
		end
		
		describe "creating new question" do
			let(:model_params) { double(:model_params) }
			before { 
								@subject = FactoryGirl.create(:subject)
								@unit = FactoryGirl.create(:unit, subject_id:@subject.id) 
							}
			context "when atleast one unit is present in the subject" do
				it "It assigns new question" do
					get :new
					assigns(:subjects).should eq(Subject.all)
					assigns(:units).should eq(Unit.all)
					assigns(:question_tags).should eq(QuestionTag.all)
					assigns(:question)
				end
				it "renders the new template" do
					get :new
					response.should render_template :new
				end
			end
			context "when no unit is present" do
				before { Unit.delete_all }
				it "should display error message" do
					get :new
					flash[:error].should_not be_nil
				end
				it "should redirects to index" do
					get :new
					response.should redirect_to portal_questions_path
				end	
			end
		end

		describe " create a question" do
			let(:model_params) { double(:model_params) }
			before { Portal::QuestionsController::QuestionParams.stub(:build) { model_params} }				
			before { Question.stub(:new).and_return(question) }				
			it "saves the question" do
				question_details = FactoryGirl.attributes_for(:question)
				question.should_receive(:save)
				post :create, question: question_details
			end
			context "when the question is saved successfully" do
				before { question.stub(:save).and_return(true) }
				it "sets a flash message" do
					post :create
					flash[:notice].should_not be_nil
				end
				it "redirects to the question index" do
					post :create
					response.should redirect_to portal_questions_path
				end	
			end
			context "When the question fails to save" do
				before{ question.stub(:save).and_return(false) }
				it "assigns question" do
					post :create
					assigns[:question].should be_eql(question)
				end
				it "assigns subject" do
				  post :create
				  assigns(:subjects).should eq(Subject.all)
				end
				it "and assigns units" do
				  post :create
				  assigns(:units).should eq(Unit.all)
				end
				it "and assigns question tags" do
				  post :create
				  assigns(:question_tags).should eq(QuestionTag.all)
				end
				it "re renders the new template" do
					post :create
					response.should render_template("new")
				end
			end
		end
		describe "clicks EDIT link" do
			before{ Question.stub(:find).and_return(question) }
			it "assigns subjects" do
				get :edit, id: question.id
				assigns(:subjects).should eq(Subject.all)			  
			end
			it "assigns units" do
			  get :edit, id: question.id
			  assigns(:units).should eq(Unit.all)
			end
			it "assigns question tags" do
			  get :edit, id: question.id
			  assigns(:question_tags).should eq(Question.all)
			end
			it "assigns edit the question" do
				get :edit, id: question.id
				assigns(:question)
			end
			it "renders edit template" do
				get :edit, id: question.id
				response.should render_template :edit
			end
		end
					
		describe " update a question" do
			before { Question.stub(:find).and_return(question) }
			let(:model_params) { double(:model_params) }
			before { Portal::QuestionsController::QuestionParams.stub(:build) { model_params} }
			before { question_details = FactoryGirl.attributes_for(:question) }
			it "It finds the question" do
				question.should_receive(:update).and_return(question)
				put :update, id:question.id, question: question
			end

			context "with valid question details " do
				before{ question.stub(:update).and_return(true) }
				it "displays success messages" do
					put :update, id:question.id, question: question
					flash[:notice].should eq("Question was successfully updated")
				end
				it "and redirect_to index page" do
					put :update, id: question.id, question: question
					response.should redirect_to portal_questions_path
				end	
			end
			context "invalid question details" do
				before { question.stub(:update).and_return(false) }
				it "displays the error message" do
					put :update, id:question.id, question: question
					flash[:error].should_not be_nil
				end
				it "assigns the subjects" do
				  put :update, id:question.id, question: question
				  assigns(:subjects).should eq(Subject.all)
				end
				it "assigns units" do
				  put :update, id:question.id, question: question
				  assigns(:units).should eq(Unit.all)
				end
				it "assigns question_tags" do
				  put :update, id:question.id, question: question
				  assigns(:question_tags).should eq(QuestionTag.all)
				end
				it "assigns question" do
				  put :update, id:question.id, question: question
				  assigns(:question).should eq(question)
				end
				it "renders the edit form" do
					put :update, id:question.id, question: question	
					response.should render_template :edit
				end
			end
		end
			
		describe "DELETE destroy action" do
			before { Question.stub(:find).and_return(question) }
			context "success" do
				before { question.stub(:destroy).and_return(true) }
				it "display success message" do
					delete :destroy, id: question
					flash[:notice].should eq("Successfully Deleted")
				end
				it "redirect_to index" do	
					delete :destroy, id: question
					response.should redirect_to portal_questions_path
				end	
			end
			context "failure" do
				before{ question.stub(:destroy).and_return(false) }
				it "display error message" do
					delete :destroy, id:question
					flash[:error].should_not be_nil
				end
				it "redirect_to index" do
					delete :destroy, id:question	
					response.should redirect_to portal_questions_path
				end	
			end
		end	

  	after (:each) do
	  	sign_out @user
	  end
  end
end  
