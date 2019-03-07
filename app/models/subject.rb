#Subject Model - Physics, Chemistry, Maths, Biology
class Subject
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paranoia

  #fields
  field :name
  field :description

  #relations
  has_and_belongs_to_many :scheme
  has_many :knowledgebases, class_name:'Knowledgebase', dependent: :destroy
  has_many :questions, dependent: :destroy
  has_many :question_papers, dependent: :destroy
  has_many :units, dependent: :destroy
  has_many :users, dependent: :destroy
  has_many :exams, dependent: :destroy
  has_many :reports, dependent: :destroy
  has_many :libraries, dependent: :destroy


  #validations
  validates_presence_of :name
  validates_uniqueness_of :name, :case_sensitive => false
  
  #scopes
end
