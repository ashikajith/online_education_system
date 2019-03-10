class Portal::MessageController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource except: [:delete_thread]


  def index
    @messages = Message.where(receiver_id:current_user.id).order_by(:created_at=>:desc)
    @reply_inbox_messages = Message.where(user_id:current_user.id,reply_status:true).order_by(:created_at=> :desc)
    @last_message = @messages.first
    @reply_messages = MessageReplies.where(message_id:@last_message.try(:id))
    respond_to do |format|
      format.html
      format.js
    end
  end

  def new
    respond_to do |format|
      format.js
    end
  end

  def create
    @message = Message.new(message_params)
    @message.school_id = current_user.school.id rescue nil
    @message.institution_id = current_user.institution.id
    @message.receiver_id = User.where(email:params[:message][:email]).first.id rescue nil
    @message.user_id = current_user.id
    if @message.save
      flash[:success] = "Message sent successfully"
    else
      display_errors(@message)
    end  
    redirect_to portal_message_index_path  
  end

  def show
    @last_message = @message
    if @last_message.receiver_id == current_user.id
      @last_message.update(status:true)
    end  
    respond_to do |format|
      format.js
    end
  end

  def sent
    @messages = Message.where(user_id:current_user.id).order_by(:created_at=> :desc)
    @reply_inbox_messages = MessageReplies.where(message_id:@last_message.try(:id))
    @last_message = @messages.first
    respond_to do |format|
      format.js
    end
  end

  def reply
    @old_message = Message.find(params[:id])
    @message = MessageReplies.new
    respond_to do |format|
      format.js
    end   
  end

  def send_reply
    @message = Message.find(params[:id])
    @message_replies = @message.message_replies.build(message_replies_params)
    @message_replies.user_id = current_user.id
    if @message_replies.save
      @message.update(status:false, reply_status:true)
      flash[:success] = "Message sent successfully"
    else
      display_errors(@message)
    end
    redirect_to portal_message_index_path
  end

  def edit
    
  end

  def update
    
  end

  def destroy
    if @message.destroy
      flash[:notice] = "Deleted Successfully"
    else
      display_errors(@message)
    end
    redirect_to portal_message_index_path    
  end

  def delete_thread
    @message_thread = MessageReplies.find(params[:id])
    if @message_thread.destroy
      flash[:notice] = "Deleted Successfully"
    else
      display_errors(@message_thread)
    end
    redirect_to portal_message_index_path    
  end

  private

  class MessageParams
    def self.build params
      params.require(:message).permit(:email, :title, :content)
    end
  end
  def message_params
    MessageParams.build(params)
  end

  class MessageRepliesParams
    def self.build params
      params.require(:message_replies).permit(:id,:content)
    end
  end
  def message_replies_params
    MessageRepliesParams.build(params)
  end
end