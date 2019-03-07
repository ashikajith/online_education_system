class MessageReplies
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paranoia

  field :content
  belongs_to :message
  belongs_to :user

  #validations
  validates_presence_of :content

  def sender_name
    User.find(user_id).user_detail.full_name
  end
end
