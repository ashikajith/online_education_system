class Unit
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paranoia

  #fields

  field :name
  field :year

  #realtions
  belongs_to :subject
  has_many :question_papers, dependent: :destroy
  has_many :questions, dependent: :destroy
  has_and_belongs_to_many :question_sets
  delegate :name, to: :subject, prefix:true
  has_many :knowledgebases, class_name:'Knowledgebase', dependent: :destroy
  has_many :reports
  has_many :libraries, dependent: :destroy

  #validations
  validates_presence_of :name, :subject_id
  validates_uniqueness_of :name, :case_sensitive => false
  
  #scopes
end
