class Option
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paranoia

  #fields
  field :answer_key
  
  #relationship
  belongs_to :question

  #validation
  validates_presence_of :answer_key
end
