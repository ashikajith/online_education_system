require 'spec_helper'

describe Portal::QuestionTagsController do
  describe ".When logged in as Owner" do
  	before (:each) do
			@user = User.where(role:"owner").first
    	sign_in @user
  	end

    let(:question_tag) { mock_model(QuestionTag) }

	  describe "GET 'index'" do
  		it "lists all question_tags" do
  			get :index
        assigns(:question_tags)
      end
      it "and renders the index template" do
        get :index
        response.should render_template :index
      end
      it "and response should  be_success" do
        get :index
        response.should be_success
      end
	  end

	  describe "GET #show" do
      let(:question_tag) { FactoryGirl.create(:question_tag) }
      it "it finds the question_tag" do
        get :show, id: question_tag
        assigns(:question_tag).should eq(question_tag)
      end
      it "renders the show template" do
        get :show, id: question_tag  
        response.should render_template :show
      end
	  end

	  describe "GET #new" do
      it "it creates a new question_tag" do
        get :new
        assigns(:question_tag)
      end
      it "renders new template" do
        get :new  
        response.should render_template :new
      end
	  end

	  describe "POST #create" do
      let(:model_params) { double(:model_params) }
      before { Portal::QuestionTagsController::QuestionTagParams.stub(:build) {model_params} }
	  	before { QuestionTag.stub(:new).and_return(question_tag) }
      it "saves the question_tag" do
        question_tag_details =  FactoryGirl.attributes_for(:question_tag)
        question_tag.should_receive(:save)
        post :create, question_tag: question_tag_details
      end
      context "with valid question_tag" do
        before { question_tag.stub(:save).and_return(true) }
        it "sets a flash[:notice] message" do
          post :create
          flash[:notice].should_not be_nil
        end
        it "redirects to the question_tag Index" do
          post :create
          response.should redirect_to portal_question_tags_path
        end 
      end
      context "when the question_tag fails to save" do
        before { question_tag.stub(:save).and_return(false) }
        it "assigns question_tag" do
          post :create
          assigns(:question_tag).should be_eql(question_tag)
        end
        it "re renders the new template" do
          post :create  
          response.should render_template("new") 
        end
      end
	  end
    
    describe "GET #edit" do
      before { QuestionTag.stub(:find).and_return(question_tag) }
      it "assigns edit question_tag" do
        get :edit, id: question_tag.id
        assigns(:question_tag)
      end
      it "renders edit template" do
        get :edit, id: question_tag.id
        response.should render_template :edit
      end
    end

	  describe 'PUT update' do
	    before { QuestionTag.stub(:find).and_return(question_tag) }
      let(:model_params) { double(:model_params) }
      before { Portal::QuestionTagsController::QuestionTagParams.stub(:build) { model_params} } 
      before { question_tag_details = FactoryGirl.attributes_for(:question_tag) }
      it "finds the question_tag" do
        question_tag.should_receive(:update).and_return(question_tag)
        put :update, id: question_tag.id, question_tag: question_tag
      end
      context "with valid attributes it updates question_tag and" do
        before { question_tag.stub(:update).and_return(true) }
        it "displays success message" do
          put :update, id: question_tag.id, question_tag: question_tag
          flash[:notice].should eq("Question tag was successfully Updated")
        end
        it "and redirect_to index page" do
          put :update, id: question_tag.id, question_tag: question_tag
          response.should redirect_to portal_question_tags_path
        end
      end
      context "invalid attributes" do
        before { question_tag.stub(:update).and_return(false) }
        it "displays error message and" do
          put :update, id: question_tag.id, question_tag: question_tag
          flash[:error].should_not be_nil
        end
        it "renders the edit form" do
          put :update, id: question_tag.id, question_tag: question_tag
          response.should render_template(:edit)
        end
      end
  	end

  	describe 'DELETE destroy' do
  		before { QuestionTag.stub(:find).and_return(question_tag) }
      context "success" do
        before { question_tag.stub(:destroy).and_return(true) }
        it "display success message" do
          delete :destroy, id: question_tag
          flash[:notice].should eq("Successfully Deleted...")
        end
        it "redirects to index" do
          delete :destroy, id: question_tag
          response.should redirect_to portal_question_tags_path
        end
      end
      context "failure" do
        before { question_tag.stub(:destroy).and_return(false) }
        it "display error message" do
          delete :destroy, id: question_tag
          flash[:error].should_not be_nil
        end
        it "redirects to index" do
          delete :destroy, id: question_tag
          response.should redirect_to portal_question_tags_path
        end
      end
  	end
	  			
	  after (:each) do
	  	sign_out @user
	  end
	end

end
