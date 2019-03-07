class Knowledgebase
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paranoia
  include ::Voteable
  include ::FilterKnowledgebase

  #fields
  field :title
  field :question
  field :status, type:Boolean, default:false

  #indexes
  index({ subject_id: 1})
  index({ unit_id: 1})
  index({ created_at: 1})

  #relationships
  belongs_to :user
  belongs_to :unit
  belongs_to :subject
  has_one :knowledgebase_answer, dependent: :destroy
  
  validates_presence_of :user_id
  validates_presence_of :question
  validates_presence_of :unit_id
  validates_presence_of :subject_id

  before_validation do |kb|
    subject = Unit.find(kb.unit_id).subject
    kb.subject_id = subject.id
  end 

  scope :published, where(status: true)
  scope :unpublished, where(status: false)
  scope :latest, published.order_by(:created_at => :desc).limit(10)
  scope :rated, published.order_by(:up_count => :desc).limit(10)
  scope :my_questions, lambda { |user| where(user_id:user.id) }
  scope :unapproved, lambda { |user| user.student? ? my_questions(user).unpublished : unpublished }
end
