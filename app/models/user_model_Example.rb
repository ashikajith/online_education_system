#User model - Devise model
class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paranoia
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,:registerable,
         :recoverable, :rememberable, :trackable, :validatable, :lockable,
         :token_authenticatable, :confirmable

  ## Database authenticatable
  field :email,              :type => String, :default => ""
  field :encrypted_password, :type => String, :default => ""

  ## Recoverable
  field :reset_password_token,   :type => String
  field :reset_password_sent_at, :type => Time

  ## Rememberable
  field :remember_created_at, :type => Time

  ## Trackable
  field :sign_in_count,      :type => Integer, :default => 0
  field :current_sign_in_at, :type => Time
  field :last_sign_in_at,    :type => Time
  field :current_sign_in_ip, :type => String
  field :last_sign_in_ip,    :type => String

  ## Confirmable
  field :confirmation_token,   :type => String
  field :confirmed_at,         :type => Time
  field :confirmation_sent_at, :type => Time
  field :unconfirmed_email,    :type => String # Only if using reconfirmable

  ## Lockable
  field :failed_attempts, :type => Integer, :default => 0 # Only if lock strategy is :failed_attempts
  field :unlock_token,    :type => String # Only if unlock strategy is :email or :both
  field :locked_at,       :type => Time

  ## Token authenticatable
  field :authentication_token, :type => String

  #user roles
  field :role, default:"student"

  #Status
  field :status, :type => Boolean, :default => true

  #Unique ID for students
  field :admission_no
  field :expiry_date, type:Date, default:Date.today + 10.days
  field :year
  # field :course

  #relations
  has_one :user_detail, :validate => true, :dependent => :destroy
  accepts_nested_attributes_for :user_detail
  belongs_to :institution
  belongs_to :school
  belongs_to :scheme
  belongs_to :subject
  belongs_to :course
  has_many :exams
  has_many :notifications
  has_many :reports
  has_many :messages
  has_many :leader_boards

  #TODO Refactor this
  field :institution_id, default: Institution.first.try(:id)
  
  #scopes

  before_create do |user|
    save_admit_id if user.student?
  end
  # after_create { |user| user.send_reset_password_instructions && a =  user.build_user_detail ; a.save }
  scope :iadmins, where(role:"iadmin")
  scope :istaffs, where(role:"istaff")
  scope :sadmins, where(role:"sadmin")
  scope :sstaffs, where(role:"sstaff")
  scope :mentors, where(role:"mentor")
  scope :students, where(role:"student")

  #validations
  #validate presence of institution_id unless user is owner
  # validates_presence_of :institution_id, :unless => Proc.new { |user| user.owner? } 
  validates_presence_of :school_id, :if => Proc.new { |user| user.student? }
  validates_presence_of :scheme_id, :if => Proc.new { |user| user.student? }
  validates_presence_of :subject_id, :if => Proc.new  {|user| user.mentor? } 
  validates_presence_of :role
  validates_presence_of :expiry_date, :year, :if => Proc.new { |user| user.student? } , on: :create
  validate :current_date, :if => Proc.new { |user| user.student? }, :on=> :update
  validates_presence_of :course_id, if: Proc.new { |user| user.student? }, message: 'Please select a course that is available in your area', on: :create

  def current_date
   if self.expiry_date.to_date < Date.today
      self.errors[:base] << "You cannot allote  past dates "
    end
  end

  def school_exams
    self.exams
  end

  def admit_id
    "AD" + admission_no.to_s if admission_no
  end

  #OPTIMIZE
  def save_admit_id
    self.admission_no = User.where(role:"student").map(&:admission_no).max.to_i + 1
  end

  def password_required?
    new_record? ? false : super
  end

  def owner?
    (self.role == "owner") ? true : false
  end

  def iadmin?
    (self.role == "iadmin") ? true : false
  end

  def istaff?
    (self.role == "istaff") ? true : false
  end

  def sadmin?
    (self.role == "sadmin") ? true : false
  end

  def sstaff?
    (self.role == "sstaff") ? true : false
  end

  def mentor?
    (self.role == "mentor") ? true : false
  end

  def student?
    (self.role == "student") ? true : false
  end


end
