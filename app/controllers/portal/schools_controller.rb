#Schools Controller
class Portal::SchoolsController < ApplicationController
  
  before_filter :authenticate_user!
  load_and_authorize_resource

  def index
    @schools = @schools.page(params[:page])
  end

  def show
    @user = current_user
    respond_to do |format|
      format.html
      format.js
    end
  end

  def new
    if Institution.exists?
      @institution = Institution.all
    else
      flash[:error] = "There should be atleast one registered Institution"
      redirect_to portal_schools_path
    end
  end

  def create
    unless current_user.owner?
      @school = School.new(school_params)
      @school.institution_id = current_user.institution.id
    end
  	respond_to do |format|
  		if @school.save
  			flash[:notice] = 'School was successfully created.'
  			format.html { redirect_to portal_schools_path }
  			format.xml { render :xml => @school, :status => :created, :location => @school }
  		else
        @institution = Institution.all
        flash[:error] = @school.errors.full_messages.to_sentence
  			format.html { render :action => "new" }
  			format.xml { render :xml => @school.errors, :status => :unprocessable_entity }
  		end
  	end
  end

  def edit
    if @school
      @institution = Institution.all  
    else
      flash[:error] = "Couldnt find the requested school"
      redirect_to portal_schools_path
    end
  end

  def update
  	respond_to do |format|
  		if @school.update(school_params)
  			flash[:notice] = 'School was successfully updated'
  			format.html { redirect_to portal_schools_path }
  			format.xml { render :xml => @school, :status => :created, :location => @school }
  		else
        @institution = Institution.all
        flash[:error] = @school.errors.full_messages.to_sentence
  			format.html { render :action => "edit" }
  			format.xml { render :xml => @school.errors, :status => :unprocessable_entity }
  		end
  	end
  end

  def destroy
    if @school.destroy
    	flash[:notice] = "Successfully Deleted..."
    else
      display_errors(@school)
    end
    redirect_to portal_schools_path
  end

  def display_question_sets
    @question_sets = QuestionSet.where(:school_id=>nil)
    @school = School.find params[:school_id]
    respond_to do |format|
      format.js
    end
  end

  def submit_question_set
    #OPTIMIZE this later
    @user = current_user
    @school = School.find(params[:id])
    question_sets =  params[:school][:question_sets] rescue nil
    unless question_sets.nil?
      question_sets.each do |question_set|
        @question_set = QuestionSet.where(id:question_set).first
        new_question_set = @question_set.clone
        new_question_set.school_id = @school.id
        if  new_question_set.save
         flash[:notice] = "Added Successfully"
        else
          flash[:error] = new_question_set.errors.full_messages.to_sentence
        end
      end
    else
      flash[:error] = "please select a questions set"
    end
    redirect_to portal_school_path(@school)
  end

  private 
  class SchoolParams
    def self.build params
      params.require(:school).permit!
    end
  end
  def school_params
    SchoolParams.build(params) 
  end
end