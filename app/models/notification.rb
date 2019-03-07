class Notification
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paranoia

  #fields
  field :message
  field :event_name
  field :event_id
  field :status, type: Boolean, default: false

  #relations
  belongs_to :user

  default_scope where(:status => false) 
end
