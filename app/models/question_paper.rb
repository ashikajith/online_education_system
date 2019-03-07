class QuestionPaper
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paranoia

  #fields
	field :name
	field :total
  field :order, type:Hash, default:Hash.new
  field :key

  #relationships
  belongs_to :subject
  has_and_belongs_to_many :question_sets
  has_and_belongs_to_many :questions
  belongs_to :unit
  has_many :reports

  delegate :name, to: :subject, prefix:true
  delegate :name, to: :unit, prefix:true

  #validations
  validates_presence_of :name, :subject_id, :unit_id
  validates_uniqueness_of :name, :case_sensitive => false

  #scopes
  
# regarding stack level too deep error

  # after_update do |document|
  #   self.update_attributes!(total:self.questions.size)
  # end

  # after_destroy do |document|
  #   self.update_attributes!(total:self.questions.size)
  # end
end
