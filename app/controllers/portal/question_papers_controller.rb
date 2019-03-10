class Portal::QuestionPapersController < ApplicationController
	before_filter :authenticate_user!
	load_and_authorize_resource :class => "QuestionPaper"

  def index
    @question_papers = @question_papers.page(params[:page])
  end

  def show
  
  end

  def new
    if Subject.exists? && Unit.exists?
      load_question_paper_datas
      if request.xhr?
        filter_units(params[:subject_id])
        respond_to do |format|
          format.js
        end  
      end            
    else
      flash[:error] = "Should need atleast one subject and one unit"  
      redirect_to portal_question_papers_path
    end
  end

  def create
    @question_paper = QuestionPaper.new(question_paper_params)
  	respond_to do |format|
  		if @question_paper.save
  			flash[:notice] = 'Question Paper was successfully created'
  			format.html { redirect_to portal_question_papers_path }
  			format.xml { render :xml => @question_paper, :status => :created, :location => @question_paper }
  		else
        load_question_paper_datas
  			flash[:error] = @question_paper.errors.full_messages.to_sentence
  			format.html { render :action => "new" }
  			format.xml { render :xml => @question_paper.errors, :status => :unprocessable_entity }
  		end
  	end
  end

  def edit
    load_question_paper_datas
    @units = @question_paper.subject.units
    if request.xhr?
      filter_units(params[:subject_id])
      respond_to do |format|
        format.js
      end  
    end            
  end
	
	def update
		respond_to do |format|
			if @question_paper.update(question_paper_params)
				flash[:notice] = 'Question Paper was successfully Updated'
				format.html { redirect_to portal_question_papers_path }
				format.xml { render :xml => @question_paper, :status => :created, :location => @question_paper }
			else
        load_question_paper_datas
        @units = @question_paper.subject.units
				flash[:error] = @question_paper.errors.full_messages.to_sentence
				format.html { render :action => "edit" }
				format.xml { render :xml => @question_paper.errors, :status => :unprocessable_entity }
			end
		end
	end	

  def destroy
    if @question_paper.destroy
    	flash[:notice] = "Successfully deleted"
    else
    	flash[:error] = @question_paper.errors.full_messages.to_sentence
    end
    redirect_to portal_question_papers_path	
  end

  def submit_question
    if @question_paper.update(question_paper_params)
      flash[:notice] = "Added Successfully"
    else
      flash[:error] = @question_paper.errors.full_messages.to_sentence
    end
    respond_to do |format|
      format.js
    end  
  end

  def view_details
    @question =  Question.find(params[:id])
    respond_to do |format|
      format.js
    end  
  end
  
  private 
  
  def load_question_paper_datas
    @units = Unit.all
    @subjects = Subject.all
  end
  class QuestionPaperParams
    #FIXME fix strong params whitelisting all params
    def self.build params
      params.require(:question_paper).permit!#(:name, :type, :total, :subject_id, :unit_id, :question_ids)
    end
  end
  def question_paper_params
    QuestionPaperParams.build(params)
  end
end

