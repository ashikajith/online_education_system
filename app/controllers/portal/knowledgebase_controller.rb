class Portal::KnowledgebaseController < ApplicationController
  require 'notify.rb'
  layout 'with_sidebar'
  before_filter :authenticate_user!
  before_filter :load_datas, except: [:destroy]
  load_and_authorize_resource except: [:vote_answer, :vote]

  def index
    @knowledgebase = Knowledgebase.new
    @unapproved_knowledgebases = @knowledgebases.unapproved(current_user)
    if request.xhr?
      if  params[:subject_id]
        subject_id = params[:subject_id]
        @latest = FilterKnowledgebase::WithSubject.new(subject_id).latest
        @most_rated = FilterKnowledgebase::WithSubject.new(subject_id).most_rated
        @unapproved_knowledgebases = FilterKnowledgebase::WithSubject.new(subject_id, current_user).unapproved
        @units = Subject.find(subject_id).units
      else 
        @latest = @knowledgebases.latest
        @most_rated = @knowledgebases.rated
      end
      respond_to do |format|
        format.js
      end
    else
      @latest = @knowledgebases.latest
      @most_rated = @knowledgebases.rated
    end
  end

  def load_unit_questions
    if  params[:unit_id]
      unit_id = params[:unit_id]
      @knowledgebases = FilterKnowledgebase::WithUnit.new(unit_id).all
      respond_to do |format|
        format.js
      end
    else
      render nothing: true
    end
  end

  def new
    if request.xhr?
      filter_units(params[:subject_id])
      respond_to do |format|
        format.js
      end  
    end
  end

  def create
    @knowledgebase = Knowledgebase.new(knowledgebase_params)
    @knowledgebase.user_id = current_user.id
    if @knowledgebase.save
      Notify::SubjectMentors.notify(@knowledgebase)
      # Notification.notify(current_user.id, "Knowledgebase", @knowledgebase.id)
      flash[:success] = "Question has successfully been posted"
      redirect_to portal_knowledgebase_index_path
    else
      display_errors(@knowledgebase)
      render :new
    end
  end

  def show
    unit = @knowledgebase.unit
    @related = FilterKnowledgebase::WithUnit.new(unit).related.limit(3)
    @status = @knowledgebase.status
  end

  def edit
    
  end
  
  def update
    respond_to do |format|
      if @knowledgebase.update(knowledgebase_params)    
        flash[:notice] = "Answer Submitted Successfully"
        format.html { redirect_to portal_knowledgebase_index_path}
      else
        display_errors(@knowledgebase)
        format.html{ render :action => "edit" }
      end
    end      
  end

  def reply
    @knowledgebase = Knowledgebase.find params[:id]
    @reply = @knowledgebase.knowledgebase_answer ||= @knowledgebase.build_knowledgebase_answer  
  end

  def submit_reply
    @knowledgebase = Knowledgebase.find params[:id]
    @reply = KnowledgebaseAnswer.where(:knowledgebase_id=>@knowledgebase.id).first_or_create
    @reply.user_id = current_user.id
    if @reply.update(knowledgebase_answer_params)
      flash[:success] = "Reply has been successfully posted"
      redirect_to portal_knowledgebase_index_path
    else
      display_errors(@reply)
      render :reply
    end
  end

  def destroy
    if @knowledgebase.destroy
      flash[:notice] = "Deleted successfully"
    else
      display_errors(@knowledgebase)
    end
    redirect_to portal_knowledgebase_index_path    
  end

  def vote
    if request.xhr?
      @knowledgebase = Knowledgebase.find(params[:id])
      unless @knowledgebase.current_vote(current_user)
        @knowledgebase.upvote(current_user)
      else
        @knowledgebase.upvote_toggle(current_user)
      end
      @latest = Knowledgebase.latest
      @most_rated = Knowledgebase.rated
      # @latest = Knowledgebase.desc.limit(10)
      # @most_rated = Knowledgebase.asc.limit(3)
      respond_to do |format|
        format.js
      end
    end
  end

  def vote_answer
    if request.xhr?
      @knowledgebase_answer = KnowledgebaseAnswer.find params[:id]
      unless @knowledgebase_answer.current_vote current_user
        @knowledgebase_answer.upvote current_user
      else
        @knowledgebase_answer.upvote_toggle current_user
      end
      respond_to do |format|
        format.js
      end
    end
  end

  def approve_question
    @knowledgebase = Knowledgebase.find(params[:id])
    status = @knowledgebase.status
    @knowledgebase.update(status:!status)
    redirect_to portal_knowledgebase_index_path
  end

  private
  def load_datas
    @subjects = load_my_subjects
    @units = load_my_units
  end

  class KnowledgebaseParams
    def self.build params
      params.require(:knowledgebase).permit(:id, :title,:question,:unit_id, :status)
    end
  end
  def knowledgebase_params
    KnowledgebaseParams.build(params)
  end
  def knowledgebase_answer_params
    params.require(:knowledgebase_answer).permit(:answer)
  end
end
