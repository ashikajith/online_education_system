class Portal::UsersController < ApplicationController
	before_filter :authenticate_user!
	load_and_authorize_resource

	def index
		respond_to do |format|
			format.json { render :json => @users.to_json(include: [:user_detail, :school], methods: :admit_id)}
			format.html
		end
	end

	def show
		if @user.student? and @user.reports.exists?
			event_performance(@user)
		end
		render :layout => 'user_list_view'
	end

	def new
		if Institution.exists?
			load_data
			@user = User.new
			@user_detail = @user.build_user_detail
		else
			flash[:error] = "Should atleast contain one Institution "	
			redirect_to portal_users_path
		end	 
	end

	def create
		@user = User.new(user_params)
		respond_to do |format|
			if @user.save
				flash[:notice] = "User was Successfully created"
				format.html { redirect_to portal_users_path }
				format.xml { render :xml => @user, :status => :created, :location => @user }
			else
				load_data
				a = []
				a << @user.errors.full_messages.to_sentence
				a << @user.user_detail.errors.full_messages.to_sentence
				flash[:error] = a.to_sentence
				format.html{ render :action => "new" }
				format.xml { render :xml => @user, :status => :created, :location => @user }	
			end
		end	
	end

	def edit
		if @user
			load_data
		else
			flash[:error] = "The requested user is not found"
			redirect_to portal_users_path
		end	
	end

	def update
		respond_to do |format|
			if @user.update(user_params)
				flash[:notice] = "User was Successfully updated"
				format.html { redirect_to portal_users_path }
  			format.xml { render :xml => @user, :status => :created, :location => @user }
			else
				a = []
				a << @user.errors.full_messages.to_sentence
				a << @user.user_detail.errors.full_messages.to_sentence
				flash[:error] = a.to_sentence
				load_data
				format.html { render :action => "edit" }
  			format.xml { render :xml => @user.errors, :status => :unprocessable_entity }	
			end
		end	
	end

	def destroy
		if @user.destroy
			flash[:notice] = "Successfully Deleted"
		else
			display_errors(@user)
		end
		redirect_to portal_users_path
	end

	def change_password
		@user = current_user
		render :layout => 'profile'
	end

	def update_password
		@user = current_user
    if @user.update(user_params)
      sign_in @user,:bypass => true
      flash[:notice] = "Password Updated Succesfully!!!"
      redirect_to portal_users_profile_path
    else
    	display_errors(@user)
    	render :action => "change_password"
    end
	end

	def profile
		@user = current_user
		if current_user.reports.exists?
			event_performance(current_user)
		end
		render :layout => 'profile'
	end

	def profile_edit
		@user = current_user
		render :layout => 'profile'
	end

	def update_profile
		@user = current_user
		respond_to do |format|
			if @user.update(user_profile_update_params)
				flash[:notice] = "User was Successfully updated"
				format.html { redirect_to portal_users_profile_path }
  			format.xml { render :xml => @user, :status => :created, :location => @user }
			else
				display_errors(@user)
				display_errors(@user.user_detail)
				load_data
				format.html { render :action => "profile_edit" , layout:'profile'}
  			format.xml { render :xml => @user.errors, :status => :unprocessable_entity }	
			end
		end		
	end

	def activate_account	
		@user = User.find(params[:id])
		@user.status = true
		if @user.update(user_params)
			flash[:notice] = "Your Subscription has been updated Successfully"
		else
			flash[:error] = display_errors(@user)
		end
		redirect_to portal_user_path(@user)
	end

	private

	def load_data
		@roles = Role::role(current_user.role.to_s)
		@schemes = Scheme.all
		@schools =  School.all
		@subjects = Subject.all
		@institutions = Institution.all
	end

	class	UserParams
		def self.build params
			params.require(:user).permit(:email, :institution_id, :role, :expiry_date, :school_id, :year, :scheme_id, :subject_id, :current_password, :password,:password_confirmation,
				user_detail_attributes:[:id, :gender, :photo, :syllabus, :guardian_phone_number, :guardian_name, :first_name, :last_name, :dob, :address, :pincode,
			  :state, :country, :mobile, :landline])
		end
	end

	class UserProfileUpdateParams
		def self.build params
			params.require(:user).permit(:current_password, :password, :password_confirmation,
				user_detail_attributes:[:id, :gender, :photo, :syllabus, :guardian_phone_number, :guardian_name, :first_name, :last_name, :dob, :address, :pincode,
			  :state, :country, :mobile, :landline])
		end
	end

	def user_params
		UserParams.build(params)		
	end

	def user_profile_update_params
		UserProfileUpdateParams.build(params)
	end

	def event_performance(user)
		@l1_questions_answered = user.reports.sum(:l1_attended) 
    @l2_questions_answered = user.reports.sum(:l2_attended) 
    @l3_questions_answered = user.reports.sum(:l3_attended)
    @total_l1_questions = user.reports.sum(:l1_total) 
    @total_l2_questions = user.reports.sum(:l2_total) 
    @total_l3_questions = user.reports.sum(:l3_total)  
    @question_count =  @total_l1_questions + @total_l2_questions + @total_l3_questions rescue 0
    @total_answered = @l1_questions_answered + @l2_questions_answered + @l3_questions_answered rescue 0
    @accuracy = user.reports.total_accuracy
  end
end
