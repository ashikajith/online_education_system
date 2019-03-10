class Portal::SchemesController < ApplicationController
	
  before_filter :authenticate_user!
  load_and_authorize_resource

  def index
  
  end

  def show
  
  end

  def new
    if Subject.exists?
      @subject = Subject.all
    else
      flash[:error] = "Atleast one subject need to be present"
      redirect_to portal_schemes_path
    end
  end

  def create
  	@scheme = Scheme.new(scheme_params)
  	respond_to do |format|
  		if @scheme.save
  			flash[:notice] = 'scheme was successfully created.'
  			format.html { redirect_to portal_schemes_path }
  			format.xml { render :xml => @scheme, :status => :created, :location => @scheme }
  		else
        display_errors(@scheme)
        @subject = Subject.all
  			format.html { render :action => "new" }
  			format.xml { render :xml => @scheme.errors, :status => :unprocessable_entity }
  		end
  	end
  end

  def edit
    if @scheme
      @subject = Subject.all
    else
      flash[:error] = "couldnt find the requested scheme"
      redirect_to portal_schemes_path  
    end
  end
	
	def update
	  respond_to do |format|
			if @scheme.update(scheme_params)
				flash[:notice] = 'scheme was successfully updated'
				format.html { redirect_to portal_schemes_path }
				format.xml { render :xml => @scheme, :status => :created, :location => @scheme }
			else
        display_errors(@scheme)
        @subject = Subject.all
				format.html { render :action => "edit" }
				format.xml { render :xml => @scheme.errors, :status => :unprocessable_entity }
	    end
    end
	end

  def destroy
    if @scheme.destroy
      flash[:notice] = "Successfully Deleted"
    else
      display_errors(@scheme)   
    end 
    redirect_to portal_schemes_path
  end

  private
  class SchemeParams
    def self.build params
      #FIXME Strong params
      params.require(:scheme).permit!
    end
  end
  def scheme_params
    SchemeParams.build(params)    
  end  
end