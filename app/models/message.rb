class Message
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paranoia

  field :title
  field :content
  field :email
  field :receiver_id
  field :status, type:Boolean, default:false
  field :reply_status, type:Boolean,default:false

  belongs_to :user
  belongs_to :school
  belongs_to :institution
  has_many :message_replies, :class_name=>"MessageReplies", dependent: :destroy

  validates_presence_of :title, :user_id, :content
  validates_presence_of :receiver_id, message:"not a valid user"

  def receiver_name
    User.find(receiver_id).user_detail.full_name
  end
  def sender_name
    User.find(user_id).user_detail.full_name
  end

  def class_status
    if self.status == false  
      return "status active"
    else
      return ""
    end    
  end
end
