class Portal::QuestionTagsController < ApplicationController
	
  before_filter :authenticate_user!
  load_and_authorize_resource
	

  def index
  end

  def show
  end
	
	def new
	
	end

  def create
    @question_tag = QuestionTag.new(question_tag_params)
  	respond_to do |format|
  		if @question_tag.save
  			flash[:notice] = 'Question Tag was successfully created.'
  			format.html { redirect_to portal_question_tags_path }
  			format.xml { render :xml => @question_tag, :status => :created, :location => @question_tag }
  		else
        flash[:error] = @question_tag.errors.full_messages.to_sentence
  			format.html { render :action => "new" }
  			format.xml { render :xml => @question_tag.errors, :status => :unprocessable_entity }
  		end
  	end
  end

  def edit
  end

  def update
  	respond_to do |format|
  		if @question_tag.update(question_tag_params)
  			flash[:notice] = 'Question tag was successfully Updated'
  			format.html { redirect_to portal_question_tags_path }
  			format.xml { render :xml => @question_tag, :status => :created, :location => @question_tag }
  		else
        flash[:error] = @question_tag.errors.full_messages.to_sentence
  			format.html { render :action => "edit" }
  			format.xml { render :xml => @question_tag.errors, :status => :unprocessable_entity }
  		end
  	end
  end

  def destroy
  	if @question_tag.destroy
  	 flash[:notice] = "Successfully Deleted..."
    else
      display_errors(@question_tag)
  	end
    redirect_to portal_question_tags_path
	end

  private
  class QuestionTagParams
    def self.build params
      params.require(:question_tag).permit(:name)
    end  
  end
  def question_tag_params
    QuestionTagParams.build(params)
  end
end
