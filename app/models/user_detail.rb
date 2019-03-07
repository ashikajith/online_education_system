#User Detail model - Profile
class UserDetail
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paranoia
  include Mongoid::Paperclip

  has_mongoid_attached_file :photo, :default_url => 'missing.jpg',
    :path           => ':attachment/:id/:style.:extension',
    :storage        => :s3,
    :s3_credentials => File.join(Rails.root, 'config', 's3.yml'),
    :styles => {
      :original => ['1920x1680>', :jpg],
      :small    => ['100x100#',   :jpg],
      :medium   => ['160x160',    :jpg],
      :large    => ['500x500>',   :jpg]
    },
    :convert_options => { :all => '-background white -flatten +matte' }
  #fields

  field :photo, type:File
  field :user_id
  field :first_name
  field :last_name
  field :dob, type:Date
  field :address
  field :state
  field :country
  field :pincode
  field :mobile
  field :landline
  field :guardian_name
  field :guardian_phone_number
  field :syllabus
  field :gender

  #relations
  belongs_to :user

  # validations
  validates_attachment_size :photo, :less_than=>1.megabyte
  validates_format_of :photo, :with => /[a-z A-Z 0-9].(gif|jpg|jpeg|png)/
  validates_presence_of :first_name, :last_name,:country,
                        :address,:pincode, :dob
  validates_presence_of :guardian_name, :guardian_phone_number, :if => Proc.new {|user_detail| user_detail.student?}                        
  validates_format_of :first_name, :with=> /\A[a-z A-Z]*\z/
  validates_format_of :last_name, :with=> /\A[a-z A-Z]*\z/ 
  validates_format_of :guardian_name, :with=> /\A[a-z A-Z]*\z/ 
  validate :invalid_dates 
  validates_format_of :mobile, :with=>/\A[0-9]{10}\z/ 
  validates_format_of :landline, :with=>/\A[0-9]{11}\z/
  validates_format_of :pincode, :with =>/\A[0-9]{6}\z/ 
  validates_format_of :guardian_phone_number, :with =>/\A[0-9]{10}\z/ 

  def invalid_dates
    unless self.dob.nil?
      if self.dob.to_date > Time.now.to_date
        errors.add(:dob, 'Invalid date!')
      end
    end
  end

  def full_name
    self.first_name.to_s + " " + self.last_name.to_s
  end

  #scopes

  def student?
    (self.user.role == "student") ? true : false
  end

end
