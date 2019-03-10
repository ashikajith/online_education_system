class RegistrationController < Devise::RegistrationsController
  def new
    @user = User.new
    @user_detail = @user.build_user_detail
  end

  def create
    @user = User.new(sign_up_params)
    if params[:user][:school_id].blank?
      school_name = params[:school_name]
      school_area = params[:school_area]
      institution = params[:user][:institution_id]
      school = School.new(name:school_name, area:school_area, institution_id:Institution.first.id)
      if school.save  
        @user.school_id = school.id
      end      
    end
    if @user.save
      flash[:success]= "Successfully Registered"
      redirect_to "/"
    else
      display_errors(@user)
      render 'new'
    end          
  end

  def load_fees
    query = {}
    query[:year] = params[:year]
    query[:scheme_id] = params[:scheme_id]
    query[:country] = params[:country]
    query[:state] = params[:state] unless params[:state].empty?
    query[:course_type] = params[:course_type]
    course = Course.where(query).first
    respond_to do |format|
      format.json  { render :json => course.to_json}
    end
  end

  private

  def sign_up_params
    params.require(resource_name).permit!
  end
end