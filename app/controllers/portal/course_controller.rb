class Portal::CourseController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource

  def index
    
  end

  def new
    load_schemes
  end

  def create
    @course = Course.new(course_params)
    if @course.save
      flash[:notice] = "Course Created Successfully"
      redirect_to portal_course_index_path
    else
      load_schemes
      flash[:error] = display_errors(@course)
      render 'new'
    end    
  end

  def edit
    load_schemes
  end

  def update
    if @course.update(course_params)
      flash[:notice] = "Course Updated Successfully"
      redirect_to portal_course_index_path
    else
      load_schemes
      flash[:error] = display_errors(@course)
      render 'edit'
    end    
  end

  def destroy
    if @course.destroy
      flash[:notice] = "Deleted Successfully"
    else
      flash[:error] = display_errors(@course)
    end
    redirect_to portal_course_index_path    
  end

  private

  class CourseParams
    def self.build params
      params.require(:course).permit(:online_status, :country, :course_type, :state, :fees, :year, :scheme_id)
    end
  end  
  
  def course_params
    CourseParams.build(params)
  end

  def load_schemes
    @schemes = Scheme.all
  end
end
