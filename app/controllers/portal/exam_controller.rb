class Portal::ExamController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource
  ['examiner', 'notify', 'json'].map { |file| require file }

  def index
    get_exam_schedule
    @exam = Exam.new
    render :layout => 'exam_sidebar'
  end

  def load_prev_exams
    if request.xhr?
      if  params[:subject_id] && params[:exam_type]
        get_prev_exams params[:subject_id], params[:exam_type]
        @exam = Exam.new
        respond_to do |format|
          format.js
        end
      end
    end
  end

  def new
    current_exam = current_user.exams.where(status:false).first
    if current_exam
      @exam = current_exam
      redirect_to portal_exam_path(@exam)
    else
      get_exam_schedule
    end
  end

  def create
    quest_id = params[:exam][:question_paper_id]
    @question_paper = QuestionPaper.find(quest_id)
    @exam = Exam.new(exam_params)
    @exam = Examiner::ConductExam.setup(@exam, current_user, @question_paper)
    if @exam
      Examiner::ConductExam.publish_question_paper @exam
      redirect_to portal_exam_path(@exam)
      Thread.new do
        Examiner::ConductExam.init_timer @exam, current_user
      end
    else 
      flash[:error] = "Something went wrong..!!"
      redirect_to portal_exam_index_path
    end
  end

  def load_question
    @exam = current_user.exams.where(id:params[:exam_id], status:false).first
    if @exam
      current_index = @exam.id.to_s + ":" + params[:current].to_s
      start_time = $redis.hget(current_index, 'start_time')
      end_time = Time.now
      attempt = $redis.hget(current_index, 'attempt').to_i
      status = $redis.hget(current_index, 'status')
      unless status == "answered"
        total_time = end_time.to_i - start_time.to_i
        attempt = attempt += 1  
      end
      #TODO Refactor this
      if params[:answer] != ""
        if status != "answered" && !ExamLog.where(key:current_index).exists?
          $redis.hmset(current_index, 'end_time', end_time, 'attempt', attempt, 'status', "answered", 'answer', params[:answer].to_s, 'total_time', total_time.to_s)
          hash_value = $redis.hgetall(current_index) 
          Examiner::ConductExam.save_values(@exam, hash_value, current_user, current_index)  
        end
      elsif params[:marked] != ""
        unless status == "answered"
          $redis.hmset(current_index, 'end_time', end_time, 'attempt', attempt, 'status', "marked", 'total_time', total_time.to_s)
        end  
      else
        unless status == "marked" || status == "answered"
          $redis.hmset(current_index, 'end_time', end_time, 'attempt', attempt, 'status', "seen", 'total_time', total_time.to_s)
        end
      end
      next_index = @exam.id.to_s + ":" + params[:next].to_s
      @next_question = $redis.hgetall(next_index)
      if @next_question.empty?
        @next_question = $redis.hgetall(current_index)
      else
        start_time = Time.now
        status = $redis.hget(next_index, 'status')
        if status == "unseen"
          status = "seen"
        end
        $redis.hmset(next_index, 'start_time', start_time, 'status', status)
        @next_question = $redis.hgetall(next_index)
      end
      WebsocketRails[:"#{@exam.id}"].trigger 'question', @next_question.to_json
    end
    render nothing: true
  end

  def show
    if @exam.status
      @exam_logs = @exam.exam_logs.order_by(:key => :asc)
      @total_l1_questions = @exam.exam_logs.question_type_count("l1").count
      @total_l2_questions = @exam.exam_logs.question_type_count("l2").count
      @total_l3_questions = @exam.exam_logs.question_type_count("l3").count
      @l1_questions_answered = @exam.exam_logs.question_type_count("l1").answered.count
      @l2_questions_answered = @exam.exam_logs.question_type_count("l2").answered.count
      @l3_questions_answered = @exam.exam_logs.question_type_count("l3").answered.count
      @question_count =  @exam.question_paper.questions.count
      render :result, layout: "exam_sidebar"
    else
      @question_paper = @exam.question_paper
      @question =  @question_paper.questions.first
      count = @question_paper.questions.count
      @question_status = {}
      count.times do |count|
        status = $redis.hget(@exam.id.to_s + ":#{count+1}",'status')
        @question_status[count+1] = status
      end
      render :show
    end
  end

  def unattended
    @exam_schedule = ExamSchedule.find(params[:exam_schedule_id])
    @questions = @exam_schedule.question_paper.questions
    render :layout => 'exam_sidebar'
  end

  def event_performance
    @school_id = params[:school_id]
    @school_id = nil if @school_id.blank?
    @event_performance = LeaderBoard.event_performance(current_user, @school_id)
    respond_to do |format|
      if current_user.student?
        @l1_questions_answered = current_user.reports.sum(:l1_attended) rescue 0
        @l2_questions_answered = current_user.reports.sum(:l2_attended) rescue 0
        @l3_questions_answered = current_user.reports.sum(:l3_attended) rescue 0
        @l1_total = current_user.reports.sum(:l1_attended) rescue 0
        @l2_total = current_user.reports.sum(:l2_attended) rescue 0
        @l3_total = current_user.reports.sum(:l3_attended) rescue 0
        @total_questions =  @l1_total + @l2_total + @l3_total rescue 0
        @total_answered = @l1_questions_answered + @l2_questions_answered + @l3_questions_answered rescue 0
        @accuracy = current_user.reports.total_accuracy
        format.json { render :json => @event_performance.to_json }   
        format.html { render :layout => 'exam_sidebar' }
      else
        if current_user.iadmin? || current_user.istaff?
          @rank = {}
          query = {}
          query[:school_id] = params[:school_id] unless params[:school_id].blank?
          @school_id = params[:school_id]
          query[:role] = "student"
          @overall_parameter = LeaderBoard.overall_performance @school_id
          User.where(query).each do |s|
            # @rank[s.user_detail.full_name] = ((LeaderBoard.where(user_id:s.id).avg(:rank)).to_f/(LeaderBoard.where(user_id:s.id).avg(:total_users_attended)).to_f).round(2) rescue 0
            @rank[s.user_detail.full_name] = LeaderBoard.where(user_id:s.id).sum(:mark_ratio).round(4) rescue 0
          end
        elsif current_user.sstaff? || current_user.sadmin?
          @rank = {}
          User.where(role:'student', school_id:current_user.school.id).asc(:id).each do |s|
            @rank[s.user_detail.full_name] = ((LeaderBoard.where(school_id:current_user.school.id, user_id:s.id).avg(:rank)).to_f/(LeaderBoard.where(school_id:current_user.school.id, user_id:s.id).avg(:total_users_attended)).to_f).round(2) rescue 0
          end
        end
        format.json { render :json => @event_performance.to_json}
        format.html { render "performance_list", :layout => 'exam_sidebar'}
        format.js{ render "performance_list"}
      end
    end
  end

  def complete_exam
    exam = current_user.exams.where(status:false).first
    Examiner::ConductExam.complete_exam exam, current_user
    flash[:notice] = "Exam has been completed and answers has been submitted"
    redirect_to portal_exam_path(exam)
  end

  private
  class ExamParams
    def self.build params
      params.require(:exam).permit(:question_paper_id, :exam_schedule_id)
    end
  end
  def exam_params
    ExamParams.build(params)
  end

  def get_prev_exams subject_id, exam_type 
    query = {}
    query[:year] = current_user.year if current_user.year == "first"
    query[:school_id] = current_user.school.id if current_user.student?
    query[:subject_id] = subject_id
    query[:type] = exam_type
    @exams = ExamSchedule.where(query).where(exam_date:{:$lt=> Date.today})
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
