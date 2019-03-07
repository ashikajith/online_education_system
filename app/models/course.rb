class Course
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paranoia

  #fields
  field :online_status, type:Boolean, default: false
  field :country
  field :course_type
  field :state
  field :fees
  field :year

  #relationship
  belongs_to :scheme
  has_many :users

  validates_presence_of :course_type, :fees, :year, :country
end
