class Portal::SubjectsController < ApplicationController
	
  before_filter :authenticate_user!
  load_and_authorize_resource

  def index
  
  end

  def show
  
  end
	
	def new
	
	end	

  def create
    @subject = Subject.new(subject_params)
  	respond_to do |format|
  		if @subject.save
  			flash[:notice] = 'Subject was successfully created.'
  			format.html { redirect_to portal_subjects_path }
  			format.xml { render :xml => @subject, :status => :created, :location => @subject }
  		else
  			display_errors(@subject)
  			format.html { render :action => "new" }
  			format.xml { render :xml => @subject.errors, :status => :unprocessable_entity }
  		end
  	end
  end

  def edit
  
  end

  def update
  	respond_to do |format|
  		if @subject.update(subject_params)
  			flash[:notice] = 'subject was successfully updated'
  			format.html { redirect_to portal_subjects_path }
  			format.xml { render :xml => @subject, :status => :created, :location => @subject }
  		else
  			display_errors(@subject)
  			format.html { render :action => "edit" }
  			format.xml { render :xml => @subject.errors, :status => :unprocessable_entity }
  		end
  	end
  end

  def destroy
    if @subject.destroy
      flash[:notice] = "Successfully Deleted"
    else
      display_errors(@subject)  
    end 
    redirect_to portal_subjects_path
  end

  private
  class SubjectParams
    def self.build params
      params.require(:subject).permit(:name, :description)
    end
  end
  def subject_params
    SubjectParams.build(params)    
  end  
end	