class KnowledgebaseAnswer
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paranoia
  include ::Voteable

  #fields
  field :answer

  #index
  index({ created_at: 1})
  index({ user_id: 1})

  #relations
  belongs_to :user
  belongs_to :knowledgebase

  #validations
  validates_presence_of :user_id, :answer

end
