#Application Controller
class ApplicationController < ActionController::Base
  protect_from_forgery
    layout :layout_by_resource
  #Handle cancan access denied exception
  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = exception.message
    redirect_to portal_dashboard_path
  end

  def after_sign_in_path_for(resource)
    if current_user.student?
      if current_user.expiry_date < Date.today
        current_user.update_attribute(:status, false)
        flash[:error] = "Your Account is Deactivated"
      end
      return portal_dashboard_wall_path
    end        
    portal_dashboard_path
  end  

  def current_ability
    @current_ability ||= Ability.new(current_user)
  end

  def school_exams
  	Exam.where(school_id:current_user.school.id)	
  end

  def display_errors(model)
    flash[:error] = model.errors.full_messages.to_sentence
  end

  def load_my_subjects
    my_subjects = current_user.scheme.subjects if current_user.student?
    my_subjects = current_user.subject.to_a if current_user.mentor?
    my_subjects ||= Subject.all
  end

  def load_my_units
    my_units = []
    load_my_subjects.map { |s| s.units.map { |u| my_units << u }}
    return my_units
  end

  before_filter do
    resource = controller_name.singularize.to_sym
    method = "#{resource}_params"
    params[resource] &&= send(method) if respond_to?(method, true)
  end

  before_filter :configure_permitted_parameters, if: :devise_controller?

  protected

  def layout_by_resource
    if devise_controller?
      "log_in"
    else
      "application"
    end
  end

  def filter_units (subject_id)
    if subject_id
      subject = Subject.find(subject_id) unless subject_id.blank?
      @units = subject.units rescue ""
    end
  end

  #TODO Refactor this
  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:email, :institution_id, :role, :school_id, :scheme_id, :course_id,:subject_id,:expiry_date,:year, :current_password, :password,:password_confirmation,
            user_detail_attributes:[:id, :photo, :first_name, :gender, :guardian_name, :guardian_phone_number, :last_name, :dob, :address, :pincode,
            :city, :state, :country, :mobile, :landline, :about]) }
    devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:email, :password, :remember_me) }
  end

end