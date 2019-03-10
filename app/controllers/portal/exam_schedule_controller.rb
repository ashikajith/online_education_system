class Portal::ExamScheduleController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource

  def index
    @exam_schedules = ExamSchedule.all
  end

  def new
    load_data
    if request.xhr?
      if params[:school_id]
        @school = School.find(params[:school_id])
        @question_sets = @school.question_sets
      end
      respond_to do |format|
        format.js
      end
    end
  end

  def create
    errors = []
    school = School.find(params[:school_id])
    question_set = QuestionSet.find(params[:question_set_id])
    exam_date = params[:exam_schedule][:exam_date]
    interval = params[:exam_schedule][:interval].to_i
    errors = ExamSchedule.schedule(question_set, school, exam_date.to_date, interval)
    if errors.nil?
      flash[:success] = "Exam Scheduled Successfully"
      redirect_to portal_exam_schedule_index_path 
    else 
      flash[:error] = errors
      load_data
      render 'new'
    end
  end

  def show

  end  

  def edit
    if @exam_schedule.exam_date > Date.today
      load_data
      if request.xhr?
        if params[:school_id]
          @school = School.find(params[:school_id])
          @question_sets = @school.question_sets
        end
        respond_to do |format|
          format.js
        end    
      end
    else
      flash[:error] = "You cant modify todays Schedule" 
      redirect_to portal_exam_schedule_index_path
    end   
  end

  def update
    errors = []
    school = School.find(params[:school_id])
    question_set = QuestionSet.find(params[:question_set_id])
    exam_date = params[:exam_schedule][:exam_date]
    type = params[:exam_schedule][:type]
    interval = params[:exam_schedule][:interval].to_i
    p interval
    errors = @exam_schedule.schedule(question_set, school, exam_date.to_date, interval)
    if errors.nil?
      flash[:success] = "Updated Successfully"
      redirect_to portal_exam_schedule_index_path
    else
      flash[:error] = errors.uniq!
      load_data
      render 'edit'
    end    
  end

  def destroy
    if @exam_schedule.exam_date > Date.today
      if @exam_schedule.destroy
        flash[:notice] = "Successfully deleted"
      else
        flash[:error] = display_errors(@exam_schedule) 
      end
    else
      flash[:error] = "You cannot delete a previously scheduled event"
    end  
    redirect_to portal_exam_schedule_index_path
  end

  private
  class ExamScheduleParams
    def self.build params
      params.require(:exam_schedule).permit!#(:exam_date,:type, :interval, :school_id, :question_paper_id)
    end
  end
  def exam_schedule_params
    ExamScheduleParams.build(params)    
  end

  def load_data
    @schools = School.all
    @question_sets = QuestionSet.all
  end
end
