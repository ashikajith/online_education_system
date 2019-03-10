class Portal::UnitsController < ApplicationController
	
  before_filter :authenticate_user!
  load_and_authorize_resource

  def index
    @units = @units.page(params[:page])
  end

  def show
  
  end

  def new
    if Subject.exists?
      @subjects = Subject.all
    else
      flash[:error] = "Should have atleast one subject"
      redirect_to portal_units_path
    end    
  end

  def create
    @unit = Unit.new(unit_params)
  	respond_to do |format|
  		if @unit.save
  			flash[:notice] = 'Unit was successfully created'
  			format.html { redirect_to portal_units_path }
  			format.xml { render :xml => @unit, :status => :created, :location => @unit }
  		else
  			display_errors(@unit)
        @subjects = Subject.all
  			format.html { render :action => "new" }
  			format.xml { render :xml => @unit.errors, :status => :unprocessable_entity }
  		end
  	end
  end

  def edit
    if @unit
      @subjects = Subject.all
    else
      flash[:error] = "Could not find the requested unit"
      redirect_to portal_units_path
    end    
  end
	
	def update
		respond_to do |format|
			if @unit.update(unit_params)
				flash[:notice] = 'Unit was successfully updated'
				format.html { redirect_to portal_units_path }
				format.xml { render :xml => @unit, :status => :created, :location => @unit }
			else
        display_errors(@unit)
        @subjects = Subject.all
				format.html { render :action => "edit" }
				format.xml { render :xml => @unit.errors, :status => :unprocessable_entity }
			end
		end
	end

  def destroy
    if @unit.destroy
      flash[:notice] = "Successfully Deleted"
    else
      display_errors(@unit)  
    end
    redirect_to portal_units_path
  end

  private
  class UnitParams
    def self.build params
      params.require(:unit).permit(:subject_id, :name, :order, :year)  
    end
  end
  def unit_params
    UnitParams.build(params)    
  end  
end