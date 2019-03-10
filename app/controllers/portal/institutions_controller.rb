class Portal::InstitutionsController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource 

  def index
    @institutions = @institutions.page(params[:page])
  end

  def show
  
  end

  def new
  
  end

  def create
    @institution = Institution.new(institution_params)
    respond_to do |format|
      if @institution.save
        flash[:notice] = 'Institution was successfully created.'
        format.html { redirect_to portal_institutions_path }
        format.xml { render :xml => @institution, :status => :created, :location => @institution }
      else
        display_errors(@institution)
        format.html { render :action => "new" }
        format.xml { render :xml => @institution.errors, :status => :unprocessable_entity }
      end
    end
  end

  def edit
    
  end

  def update
    respond_to do |format|
      if @institution.update(institution_params)
        flash[:notice] = 'Institution was successfully updated.'
        format.html { redirect_to portal_institutions_path }
        format.xml { render :xml => @institution, :status => :created, :location => @institution }
      else
        display_errors(@institution)
        format.html { render :action => "edit" }
        format.xml { render :xml => @institution.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    if @institution.destroy
      flash[:notice] = "Successfully Deleted..."
    else
      display_errors(@institution) 
    end
    redirect_to portal_institutions_path
  end

  private
  class InstitutionParams
    def self.build params
      params.require(:institution).permit(:name, :address, :area,
                                        :city, :state, :country, :pincode, :email,
                                        :phone, :website)
    end
  end
  def institution_params
    InstitutionParams.build(params)
  end
end
