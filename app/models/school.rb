#School Model
class School
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paranoia

  #fields
  field :name
  field :address
  field :area
  field :city
  field :state
  field :country
  field :pincode
  field :landline
  field :mobile
  field :email
  field :website

  #relations
  belongs_to :institution
  has_many :question_sets
  has_many :exams
  has_many :reports
  has_many :messages
  has_many :leader_boards
  #delegations
  delegate :name, to: :institution, prefix:true

  #validations
  validates_presence_of :name, :institution_id, :area
  validates_uniqueness_of :name, :case_sensitive => false
  validates_format_of :city, :state, :country, :with=> /\A[a-z A-Z]*\z/, :on => :update
  validates_format_of :area, :with=> /\A[a-z A-Z 0-9]*\z/, :on=> :update
  validates_format_of :mobile, :with=>/\A[0-9]{10}\z/, :on=>:update
  validates_format_of :landline, :with=>/\A[0-9]{11,15}\z/, :on=> :update
  validates_format_of :email, :with=>/\A([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,3})\z/, :on =>:update
  validates_format_of :website, :with => /\A(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,4}?(\/.*)?\Z/ix, :allow_blank => true, :on=>:update
  validates_format_of :pincode, :with =>/\A[0-9]{6}\z/, :on =>:update
  #scopes

end
