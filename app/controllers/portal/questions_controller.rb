class Portal::QuestionsController < ApplicationController
  before_filter :authenticate_user!
	load_and_authorize_resource

  def index
    @questions = @questions.page(params[:page])
  end

  def show
  
  end

  def new
    if Subject.exists? && Unit.exists?
      load_question_datas
      5.times do 
        @question.options.build
      end
    else
      display_errors(@question)
      redirect_to portal_questions_path
    end
    if request.xhr?
      unless params[:subject_id].blank?
        subject = Subject.find(params[:subject_id])
        @units = subject.units
      end  
    end
  end

  def create
    @question = Question.new(question_params)
  	respond_to do |format|
  		if @question.save
        @question.options.each_with_index do |op,index|
          if index+1 == params[:question][:correct_option].to_i
            @question.update(correct_option:op.id)
          end
        end
  			flash[:notice] = 'Question was successfully created'
  			format.html { redirect_to portal_questions_path }
  		else
        load_question_datas
  			display_errors(@question)
  			format.html { render :action => "new" }
  		end
  	end
  end

  def edit
    if @question
      load_question_datas
    else
      flash[:error] = display_errors(@question)
      redirect_to portal_questions_path  
    end

  end
	
	def update
		respond_to do |format|
			if @question.update(question_params)
        @question.options.each_with_index do |op,index|  
          if index+1 == params[:question][:correct_option].to_i
            @question.update(correct_option:op.id)
          end
        end  
				flash[:notice] = 'Question was successfully updated'
				format.html { redirect_to portal_questions_path }
				format.xml { render :xml => @question, :status => :created, :location => @question }
			else
        load_question_datas
				display_errors(@question)
				format.html { render :action => "edit" }
				format.xml { render :xml => @question.errors, :status => :unprocessable_entity }
			end
		end
	end	

  def destroy
    if @question.destroy
    	flash[:notice] = "Successfully Deleted"
    else
    	display_errors(@question)
    end
    redirect_to portal_questions_path	
  end

  private 

  class QuestionParams
    def self.build params
      params.require(:question).permit!#(:questions, :explanation, :correct_option, :question_tag_ids, :subject_id, :unit_id, :level, options_attributes:[:answer_key])
    end
  end  
  def question_params
    QuestionParams.build(params)
  end
  
  def load_question_datas
    if current_user.mentor?
      @subjects = current_user.subject.to_a
      @units = current_user.subject.units
    else
      @subjects = Subject.all
      @units = Unit.all
    end
    @question_tags = QuestionTag.all
  end
end

