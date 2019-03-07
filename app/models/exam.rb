class Exam
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paranoia

  #fields
  field :start_time
  field :end_time
  field :status, type:Boolean, default:false
    
  #associations
  belongs_to :school
  belongs_to :user
  belongs_to :subject
  belongs_to :question_paper
  belongs_to :exam_schedule
  has_many :exam_logs
  has_many :reports

  # scope :between, lambda {|start_time, end_time|
  #   {:conditions => ["starts_at > ? and starts_at < ?", Exam.format_date(start_time), Exam.format_date(end_time)] }
  # }

  # def as_json(options = {})
  #   {
  #     :id => self.id,
  #     :title => "30/70",
  #     :descriptione. => self.user.email || "",
  #     :start => self.reports.first.eamrfc822,
  #     :end => exam_date.rfc822,
  #     :allDay => self.all_day,
  #     :recurring => false,
  #     # :url => Rails.application.routes.url_helpers.event_performance_path(id)
  #     :url => Rails.application.routes.url_helpers.portal_exam_event_performance_path(id)
  #   }
  # end

  # def self.between(start_time, end_time)
  #   Report.where(:exam_date.gte => (start_time).to_date, :exam_date.lte => (end_time).to_date)
  # end

  

  #validations
  validates_presence_of :user_id, :question_paper_id, :school_id, :exam_schedule_id
  validates_uniqueness_of :question_paper_id, :exam_schedule_id, :scope => :user_id
  #scopes 

  #create dummy datas

  def self.create_exam_schedule(s,date)
    s.question_sets.each do |qs|
      date = date
      ExamSchedule.schedule_data(qs,s,date)
      count = qs.question_papers.count
      date = date + count.days
      puts date
    end  
  end

  def self.make_dummy(school)
    ExamSchedule.all.each do |exam_schedule|
      User.where(role:"student").each do |user|  
        exam = Exam.create!(school_id:school.id,user_id:user.id,exam_schedule_id:exam_schedule.id,
            question_paper_id:exam_schedule.question_paper.id, subject_id:exam_schedule.subject.id, status:true)
        qp = exam_schedule.question_paper  
        qp.questions.each do |question|
          quest_option = question.options.map{|option| option.id }
          quest_option << ""
          option = quest_option.sample
          time_taken = (45..140).to_a.sample
          if option == ""
            time_taken = 0
            attempt = 0
          else
            attempt = [2,3,4].sample
          end
          ExamLog.create!(exam_id:exam.id, question_paper_id: qp.id, user_id:user.id, 
            correct_option:question.correct_option, question_id:question.id, 
            time_taken:time_taken, answered:option,
            attempt:attempt, level:question.level)
        end
        Report.create_report(exam,user)
      end  
    end
    Report.all.map{|e| e.update(year:["first","second"].sample)}   
  end

  def self.delete_datas
    Exam.delete_all
    ExamLog.delete_all
    Report.delete_all
  end
end