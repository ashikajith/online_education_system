class Portal::DashboardController < ApplicationController
  layout 'dashboard'
	before_filter :authenticate_user!
	
	def index
		
    # render :layout => 'dashboard'
	end

  def wall
    @todays_exams = get_exam_schedule
    loading_to_hash @todays_exams
    if current_user.reports.exists?
      @todays_summarys = current_user.reports.where(exam_date:Date.today)
      @total_l1_questions = current_user.reports.where(exam_date:Date.today).sum(:l1_total) 
      @total_l2_questions = current_user.reports.where(exam_date:Date.today).sum(:l2_total) 
      @total_l3_questions = current_user.reports.where(exam_date:Date.today).sum(:l3_total) 
      @l1_questions_answered = current_user.reports.where(exam_date:Date.today).sum(:l1_attended) 
      @l2_questions_answered = current_user.reports.where(exam_date:Date.today).sum(:l2_attended) 
      @l3_questions_answered = current_user.reports.where(exam_date:Date.today).sum(:l3_attended) 
      @question_count =  @total_l1_questions + @total_l2_questions + @total_l3_questions rescue 0
      @total_answered = @l1_questions_answered + @l2_questions_answered + @l3_questions_answered rescue 0
    end
    render :layout=>'wall_layout'
  end
  
  private

   def loading_to_hash exams
    @exam_hash = { }
    exams.each do |exam|
      @exam_hash[exam.question_paper] = exam.id
    end
    return @exam_hash
  end

  def get_exam_schedule
    query = {}
    query[:year] = current_user.year if current_user.year == "first"
    query[:exam_date] = Date.today
    query[:school_id] = current_user.school.id if current_user.student?
    subjects = current_user.scheme.subjects rescue Subject.all
    @exams = ExamSchedule.where(query).any_in(subject_id:subjects.map(&:id))
  end
end
