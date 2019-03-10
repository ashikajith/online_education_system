class Portal::QuestionSetsController < ApplicationController
	before_filter :authenticate_user!
	load_and_authorize_resource 

  def index
  
  end

  def show
  
  end

  def new
  
  end

  def create
    @question_set = QuestionSet.new(question_set_params)
  	respond_to do |format|
  		if @question_set.save
  			flash[:notice] = 'Question Paper was successfully created'
  			format.html { redirect_to portal_question_sets_path }
  			format.xml { render :xml => @question_set, :status => :created, :location => @question_set }
  		else
  			flash[:error] = @question_set.errors.full_messages.to_sentence
  			format.html { render :action => "new" }
  			format.xml { render :xml => @question_set.errors, :status => :unprocessable_entity }
  		end
  	end
  end

  def edit
  
  end
	
	def update
		respond_to do |format|
			if @question_set.update(question_set_params)
				flash[:notice] = 'Question Set was successfully updated'
				format.html { redirect_to portal_question_sets_path }
				format.xml { render :xml => @question_set, :status => :created, :location => @question_set }
			else
				display_errors(@question_set)
				format.html { render :action => "edit" }
				format.xml { render :xml => @question_set.errors, :status => :unprocessable_entity }
			end
		end
	end	

  def destroy
    if @question_set.destroy
    	flash[:notice] = "successfully deleted"
    else
    	display_errors(@question_set)
    end
    redirect_to portal_question_sets_path	
  end

  def submit_question_paper
    if @question_set.update(question_set_params)
      flash[:notice] = "Added Successfully"
    else
      flash[:error] = @question_paper.errors.full_messages.to_sentence
    end
    respond_to do |format|
      format.js
    end  
  end

  private
  class QuestionSetParams
    def self.build params
      params.require(:question_set).permit!
    end
  end
  def question_set_params
    QuestionSetParams.build(params)      
  end
end
