class QuestionTag
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paranoia

  #fields
  field :name

  #relationships
  has_and_belongs_to_many :questions

  #validations
  validates_presence_of :name
  validates_uniqueness_of :name, :case_sensitive => false
  validates_format_of :name , :with =>/\A[a-z A-Z 0-9 .()-]*['?]*[a-z A-Z 0-9 .()-]+\z/
  
  #scopes
end
