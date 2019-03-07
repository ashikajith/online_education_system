class Library
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paranoia
  include Mongoid::Paperclip

  has_mongoid_attached_file :synopsis_file
  has_mongoid_attached_file :ebook_file
  has_mongoid_attached_file :ebook_image
  has_mongoid_attached_file :synopsis_image
  # has_mongoid_attached_file , :default_url => 'no_image.png'
  
  #fields
  field :year
  field :synopsis_file, type:File
  field :ebook_file, type:File
  field :synopsis_image, type:File
  field :ebook_image, type:File

  
  #validation
  validates_presence_of :synopsis_file, :unless=> lambda { |object| object.ebook_file.present? }
  validates_presence_of :ebook_file, :unless=> lambda { |object| object.synopsis_file.present? }
  validates_attachment_content_type :synopsis_file,:ebook_file, :content_type => ["application/pdf", "application/x-pdf"], message:"Kindly upload pdf files only"
  validates_attachment_content_type :ebook_image, :synopsis_image, :content_type => ['image/png', 'image/jpg','image/jpeg'], message:"Kindly upload image(png/jpg/jpeg) files only"

  def synopsis_file_attached?
    self.synopsis_file.file?
  end

  def ebook_file_attached?
    self.ebook_file.file?
  end

  #association  
  belongs_to :subject
  belongs_to :unit

end


