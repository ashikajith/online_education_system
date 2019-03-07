#Institution Model
class Institution
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
  field :phone
  field :email
  field :website

  #relations
  has_many :users
  has_many :schools
  has_many :messages

  #validations
  
  validates_presence_of :name, :city, :state, :country, :address, :area, :phone,
                        :email
  validates_format_of :name, :city, :state, :country, :area, :with=> /\A[a-z A-Z 0-9 .]*\z/,
                      :on => :update
  validates_format_of :phone, :with=>/\A[0-9]{10}\z/, :on =>:update
  validates_format_of :email, :with=>/\A([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,3})\z/, :on =>:update
  validates_format_of :website, :with => /\A(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,4}?(\/.*)?\Z/ix
  validates_format_of :pincode, :with =>/\A[0-9]{6}\z/, :on =>:update
  #scopes
end
