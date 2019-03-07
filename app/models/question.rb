#Question Model
class Question
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paranoia

  #fields
  field :questions
  field :explanation
  field :correct_option
  field :level

  #validations
  validates_presence_of :questions, :unit_id, :subject_id
  validates_presence_of :explanation, :correct_option

  #relationships
  has_and_belongs_to_many :question_papers
  belongs_to :subject
  has_and_belongs_to_many :question_tags#, :dependent=> :destroy
  belongs_to :unit
  has_many :options, dependent: :destroy
  accepts_nested_attributes_for :options

  delegate :name, to: :subject, prefix:true
  delegate :name, to: :unit, prefix:true

  def correct_option_value
    Option.find(self.correct_option).answer_key
  end
end
