#Scheme model - Engg/Bio/Both
class Scheme
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paranoia

  #fields
  field :name
  
  #relations
  has_many :user
  has_and_belongs_to_many :subjects

  #validations
  validates_presence_of :name, :subject_ids
  validates_uniqueness_of :name, :case_sensitive => false
  
  #scopes
  def engg
    return true if self.name == "Engineering"
  end

  def medical
    return true if self.name == "Medical"
  end

  def both
    return true if self.name == "Both"
  end
end
