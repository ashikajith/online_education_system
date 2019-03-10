require 'spec_helper'

describe Portal::UnitsController do

	describe "When logged in as Owner" do
  	before (:each) do
  		@user = User.where(role:"owner").first
  		@subject = FactoryGirl.create(:subject)
    	sign_in @user
  	end

  	let(:unit) { mock_model(Unit)}

  	describe "When user visits index" do
  		it "list all the units" do
  			get :index
  			assigns(:units)
  		end
  		it "renders the index template" do
  			get :index
  			response.should render_template :index
  		end
  		it "response should be_success" do
        get :index
  			response.should be_success
  		end		
  	end

  	describe "selects a unit" do 
  		let(:unit) { FactoryGirl.create(:unit, subject_id:@subject.id) }
  		it "It finds the unit" do 
  			get :show, id:unit
  			assigns(:unit).should eq(unit)
  		end
  		it "renders the show template" do
  			get :show, id: unit
  			response.should render_template :show
  		end
  	end

  	describe "new unit" do
  		before { FactoryGirl.create(:subject, name:"new1") }
  		context "When atleast on subject is present" do
		  	it "It creates a new unit" do
		  		get :new
		  		assigns(:unit)
		  	end
		  	it "renders new template" do
		  		get :new	
		  		response.should render_template :new
		  	end
	  	end
	  	context "when no subjects are present" do
	  		before { Subject.delete_all}
	  		it "should display error message" do
	  			get :new
	  			flash[:error].should_not be_nil
	  		end
	  		it "and should redirect to index page" do
	  			get :new
	  			response.should redirect_to portal_units_path
	  		end
	  	end
	  end

	  describe "create a new unit" do
      let(:model_params) { double(:model_params) }
	  	before { Unit.stub(:new).and_return(unit) }
      before { Portal::UnitsController::UnitParams.stub(:build) { model_params} }
      it "saves the unit" do
	  		unit_details = FactoryGirl.attributes_for(:unit)
	  		unit.should_receive(:save)  		
	  		post :create, unit: unit_details
	  	end
	  	context "with valid Unit name is entered" do
	  		before { unit.stub(:save).and_return(true) }
	  		it "sets a flash[:notice] message" do
	  			post :create
	  			flash[:notice].should_not be_nil
	  		end
	  		it "redirects to the Unit index" do
	  			post :create
	  			response.should redirect_to portal_units_path
	  		end
	  	end			
	  	context "When the Unit fails to save" do
	  		before { unit.stub(:save).and_return(false) } 
	  		it "assigns Unit" do 
	  			post :create
	  			assigns(:unit).should be_eql(unit)
	  		end
	  		it "re renders the new template" do
	  			post :create
	  			response.should render_template :new
	  		end	
	  	end
	  end

	  describe "edit a existing unit" do
	  	before { Unit.stub(:find).and_return(unit) }
	  	it "assigns edit unit" do
	  		get :edit, id:unit.id
	  		assigns(:unit)
	  	end
	  end		
	  
	  describe 'update a unit' do
	  	before { Unit.stub(:find).and_return(unit) }
      let(:model_params) { double(:model_params)}
      before { Portal::UnitsController::UnitParams.stub(:build) {model_params} } 
	  	before { unit_details = FactoryGirl.attributes_for(:unit)}
      it "finds the unit" do
	  		unit.should_receive(:update).and_return(unit)
	  		put :update, id:unit.id, unit:unit
	  	end	
	  	context "with valid unit details" do
	  		before { unit.stub(:update).and_return(true) }
	  		it "displays success message" do
	  			put :update, id: unit.id, unit:unit
	  			flash[:notice].should eq("Unit was successfully updated")
	  		end
	  		it "and redirects to index page" do
	  			put :update, id:unit.id, unit: unit
	  			response.should redirect_to portal_units_path
	  		end
	  	end
  		context "with invalid attributes" do
  			before { unit.stub(:update).and_return(false) }
  			it "error message must be displayed" do
  				put :update, id: unit.id, unit:unit
  				flash[:error].should_not be_nil
  			end
  			it "renders the edit form" do
  				put :update, id: unit.id, unit:unit
  				response.should render_template(:edit)
  			end
  		end
  	end

  	describe "delete a unit" do
	  	before { Unit.stub(:find).and_return(unit) }
	  	context "success" do
	  		before { unit.stub(:destroy).and_return(true) }
	  		it "display success message" do
	  			delete :destroy, id: unit
	  			flash[:notice].should eq("Successfully Deleted")
	  		end
	  		it "redirects to index" do
	  			delete :destroy, id: unit
	  			response.should redirect_to portal_units_path
	  		end
	  	end
	  	context "failure" do
	  		before{ unit.stub(:destroy).and_return(false) }
	  		it "display error message" do
	  			delete :destroy, id: unit
	  			flash[:error].should_not be_nil
	  		end
		  	it "redirects to index" do
		  		delete :destroy, id: unit
		  		response.should redirect_to portal_units_path
		  	end
	  	end
	  end	

		after (:each)	do
			sign_out @user
			@subject.destroy
		end
  end			
end
