require 'spec_helper'

describe Portal::QuestionPapersController do	
	describe "When Logged in as owner" do
		before(:all) do
			@subject = FactoryGirl.create(:subject)
			@unit = FactoryGirl.create(:unit, subject_id:@subject.id)
		end
		before(:each) do
			@user = User.where(role:"owner").first
			sign_in @user
		end

		let(:question_paper) { mock_model(QuestionPaper)}

		describe "when user visits 'index'" do
			it "It list all the question papers" do
				get :index
				assigns(:question_papers)
			end
			it "renders the index template" do
				get :index	
				response.should render_template :index
			end
			it "response should be_success" do
				response.should be_success
			end	
		end
		
		describe "selecting a question paper" do
			let(:question_paper) { FactoryGirl.create(:question_paper, subject_id:@subject.id, unit_id:@unit.id) }
			it "It should display the question in the question paper" do
				get :show, id:question_paper
				assigns(:question_paper).should eq(question_paper)
			end
			it "render the show template" do
				get :show, id:question_paper	
				response.should render_template :show
			end
		end

		describe "new question paper" do
			before { 
				@subject = FactoryGirl.create(:subject)
				@unit = FactoryGirl.create(:unit, subject_id:@subject.id) 
			}
			context "when atleast one unit is present in the subject" do				
				it "should render the new form" do
					get :new
					assigns(:question_paper)
				end
				it "assigns units" do
				  get :new
				  assigns(:units).should eq(Unit.all)
				end
				it "assigns subjects" do
				  get :new
				  assigns(:subjects).should eq(Subject.all)
				end
				it "renders a new template" do
					get :new	
					response.should render_template :new
				end
			end
			context "when no subject is present" do
				before { Subject.delete_all }
				it "should display error message" do
					get :new
					flash[:error].should_not be_nil
				end
				it "should redirect_to index" do
					get :new
					response.should redirect_to portal_question_papers_path
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
					response.should redirect_to portal_question_papers_path
				end	
			end
		end

		describe "create a question_paper" do
			let(:model_params) { double(:model_params) }
			before { Portal::QuestionPapersController::QuestionPaperParams.stub(:build) {model_params} }
			before { QuestionPaper.stub(:new).and_return(question_paper) }
			it "saves the question paper" do
				question_paper_details = FactoryGirl.attributes_for(:question_paper)
				question_paper.should_receive(:save)
				post :create, question_paper: question_paper_details
			end
			context "with valid question_paper " do
				before { question_paper.stub(:save).and_return(true) }
				it "it sets a flash message" do
					post :create
					flash[:notice].should_not be_nil			
				end
				it "redirects to the question_paper index" do
					post :create	
					response.should redirect_to portal_question_papers_path
				end
			end
			context "when the question_paper fail to save" do
				before { question_paper.stub(:save).and_return(false) }
				it "displays flash error message" do
				  post :create
				  flash[:error].should_not be_nil
				end
				it "assigns units" do
				  post :create
				  assigns(:units).should eq(Unit.all)
				end
				it "assigns subjects" do
				  post :create
				  assigns(:subjects).should eq(Subject.all)
				end
				it "assigns QuestionPaper" do
					post :create
					assigns(:question_paper).should be_eql(question_paper)
				end
				it "re renders the new template" do
					post :create
					response.should render_template :new
				end
			end			
		end

		describe "edit a existing question_paper" do
	  	before { QuestionPaper.stub(:find).and_return(question_paper) }
	  	it "assigns units" do
	  	  get :edit, id: question_paper.id
	  	  assigns(:units).should eq(Unit.all)
	  	end
	  	it "assigns subjects" do
	  	  get :edit, id: question_paper.id
	  	  assigns(:subjects).should eq(Subject.all)
	  	end
	  	it "assigns edit question_paper" do
	  		get :edit, id:question_paper.id
	  		assigns(:question_paper)
	  	end
	  	it "renders the edit form" do
	  	  get :edit, id: question_paper.id
	  	  response.should render_template :edit
	  	end
	  end

		describe "update a question_paper" do
			before { QuestionPaper.stub(:find).and_return(question_paper) }
			let(:model_params) { double(:model_params) }
			before {Portal::QuestionPapersController::QuestionPaperParams.stub(:build) { model_params} }
			before { question_paper_details = FactoryGirl.attributes_for(:question_paper) }
			it "It  finds the q-uestion_paper" do
				question_paper.should_receive(:update).and_return(question_paper)
				put :update, id: question_paper.id, question_paper: question_paper
			end
			context "with valid question_paper details" do
				before { question_paper.stub(:update).and_return(true) }
				it "displays success message" do
					put :update, id:question_paper.id, question_paper: question_paper
					flash[:notice].should eq("Question Paper was successfully Updated")	
				end
			end
			context "with invalid question_paper details" do
				before { question_paper.stub(:update).and_return(false) }
				it "displays error message" do
					put :update, id:question_paper.id, question_paper: question_paper
					flash[:error].should_not be_nil
				end
				it "assigns units" do
				  put :update, id:question_paper.id, question_paper: question_paper
				  assigns(:units).should eq(Unit.all)
				end
				it "assigns subjects" do
				  put :update, id:question_paper.id, question_paper: question_paper
				  assigns(:subjects).should eq(Subject.all)
				end
				it "assigns question_paper" do
				  put :update, id:question_paper.id, question_paper: question_paper
				  assigns(:question_paper).should eq(question_paper)
				end
				it "renders the edit form" do
					put :update, id:question_paper.id, question_paper: question_paper
					response.should render_template(:edit)
				end	
			end
		end
			
		describe "delete a question_paper" do
	  	before { QuestionPaper.stub(:find).and_return(question_paper) }
	  	context "success" do
	  		before { question_paper.stub(:destroy).and_return(true) }
	  		it "display success message" do
	  			delete :destroy, id: question_paper
	  			flash[:notice].should eq("Successfully deleted")
	  		end
	  		it "redirects to index" do
	  			delete :destroy, id: question_paper
	  			response.should redirect_to portal_question_papers_path
	  		end
	  	end
	  	context "failure" do
	  		before{ question_paper.stub(:destroy).and_return(false) }
	  		it "display error message" do
	  			delete :destroy, id: question_paper
	  			flash[:error].should_not be_nil
	  		end
		  	it "redirects to index" do
		  		delete :destroy, id: question_paper
		  		response.should redirect_to portal_question_papers_path
		  	end
	  	end
	  end	

  	after (:each) do
	  	sign_out @user
	  end
	end	
end
