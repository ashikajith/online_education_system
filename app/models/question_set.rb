class QuestionSet
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paranoia
  include Mongoid::Attributes::Dynamic 

  #fields
  field :name
  field :total
  #relationships
	has_and_belongs_to_many :question_papers, inverse_of: nil
	has_and_belongs_to_many :units
  belongs_to :school
  belongs_to :subject
  has_many :exams


  #validations
  validates_presence_of :name
  validates_uniqueness_of :name, :scope => :school_id, message:"%{value} Have already been allotted"

  #scopes
  scope :my_questionsets, lambda { |user| user.school.question_sets}

  # after_update do |document| 
  #   self.update_attributes!(total:self.question_papers.size)
  # end

  # after_destroy do |document|
  #   self.update_attributes!(total:self.question_papers.size)
  # end
  
  def total_question_papers(question_set)
    question_set.question_papers.count
  end
end
