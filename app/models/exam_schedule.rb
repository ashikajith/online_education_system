class ExamSchedule
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paranoia

#fields
  field :exam_date, type:Date
  field :type
  field :interval
  field :year

#relations
  belongs_to :question_paper
  belongs_to :school
  belongs_to :subject  

#validations
  validates_presence_of :exam_date, :school_id, :subject_id, :question_paper_id, :type
  # validate :current_date
  
  def current_date
   if self.exam_date.to_date < Date.today
      self.errors[:base] << "Date is Invalid"
    end
  end

  after_create :update_year

  def update_year
    self.update(year:self.question_paper.unit.year)
  end

  def self.schedule question_set, school, start_date=Date.today, interval=1
    error = []
    @date = start_date
    type = exam_type interval
    question_set.question_papers.each do |question_paper|
      schedule = self.new(exam_date: @date, type: type, question_paper_id: question_paper.id, school_id: school.id, subject_id:question_paper.subject.id)
      if schedule.save
        @date = @date + interval.days
        return nil
      else      
        return error << schedule.errors.full_messages.to_sentence    
      end
    end   
  end

  def schedule question_set, school, type, start_date=Date.today, interval=1
    error = []
    @date = start_date
    question_set.question_papers.each do |question_paper|
      if self.update(exam_date: @date, type: type, question_paper_id: question_paper.id, school_id: school.id, subject_id:question_paper.subject.id)
        @date = @date + interval.days
        return nil
      else
        return error << self.errors.full_messages.to_sentence
      end
    end
  end

  def self.schedule_data question_set, school, start_date=Date.today, interval=1
    @date = start_date
    type = exam_type interval
    question_set.question_papers.each do |question_paper|
      self.create!(exam_date: @date, type: type, question_paper_id: question_paper.id, school_id: school.id, subject_id:question_paper.subject.id)
      @date = start_date + interval.days
    end
  end

  private
  def self.exam_type interval
    if interval == 1
      return "daily"
    elsif interval == 7
      return "weekly"
    else
      return "monthly"
    end
  end
end
