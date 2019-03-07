class Report
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paranoia

  field :year
  field :total_mark
  field :l1_attended
  field :l2_attended
  field :l3_attended
  field :l1_total
  field :l2_total
  field :l3_total
  field :l1_time
  field :l2_time
  field :l3_time
  field :l1_correct
  field :l2_correct
  field :l3_correct
  field :exam_date, type:Date

  belongs_to :user
  belongs_to :exam
  belongs_to :question_paper
  belongs_to :subject
  belongs_to :unit
  belongs_to :school


  #full calendar attributes

  # def as_json(options = {})
  #   {
  #     :title => "self.find_rank",
  #     :start => self.exam_date.rfc822,
  #     :end => self.exam_date.rfc822,
  #     :recurring => false
  #     # :url => Rails.application.routes.url_helpers.portal_exam_event_performance_path(id)
  #   }
  # end

  def self.total_attended
   return sum(:l1_attended) + sum(:l2_attended) + sum(:l3_attended)    
  end

  def self.total_correct
   return sum(:l1_correct) + sum(:l2_correct) + sum(:l3_correct) rescue 0
  end

  def self.total_questions
    return sum(:l1_total) + sum(:l2_total) + sum(:l3_total) rescue 0
  end

  def self.create_report(exam,user)
    qp_id = exam.question_paper.id
    sub_id = exam.subject.id
    unit_id = exam.question_paper.unit.id
    school_id = user.school.id
    year = exam.question_paper.unit.year
    tot_mark = exam.exam_logs.total_score
    l1_total = exam.exam_logs.question_type_count("l1").count
    l2_total = exam.exam_logs.question_type_count("l2").count
    l3_total = exam.exam_logs.question_type_count("l3").count
    l1_atnd = exam.exam_logs.question_type_count("l1").answered.count
    l2_atnd = exam.exam_logs.question_type_count("l2").answered.count
    l3_atnd = exam.exam_logs.question_type_count("l3").answered.count
    l1_crct = exam.exam_logs.question_type_count("l1").answered.correct.count
    l2_crct = exam.exam_logs.question_type_count("l2").answered.correct.count
    l3_crct = exam.exam_logs.question_type_count("l3").answered.correct.count
    l1_tim = exam.exam_logs.question_type_count("l1").sum(:time_taken)
    l2_tim = exam.exam_logs.question_type_count("l2").sum(:time_taken)
    l3_tim = exam.exam_logs.question_type_count("l3").sum(:time_taken)

    Report.create!(exam_id:exam.id, user_id:user.id, question_paper_id:qp_id,
            subject_id:sub_id, unit_id:unit_id, school_id:school_id,
            total_mark:tot_mark, l1_attended:l1_atnd,l2_attended:l2_atnd, l3_attended:l3_atnd ,
            l1_total:l1_total, l2_total:l2_total, l3_total:l3_total, l1_correct:l1_crct,
            l2_correct:l2_crct, l3_correct:l3_crct, l1_time:l1_tim, l2_time:l2_tim, 
            l3_time:l3_tim, year:year, exam_date:exam.exam_schedule.exam_date)
  end

  def total_attended
    self.l1_attended + self.l2_attended + self.l3_attended
  end

  def total_correct
    self.l1_correct + self.l2_correct + self.l3_correct
  end

  def accuracy
    (self.total_correct.to_f/(self.total_attended.to_f.nonzero? || 1))*100 rescue 0 
  end

  def self.accuracy
    (self.total_correct.to_f/(self.total_attended.to_f.nonzero? || 1))*100 rescue 0 
  end

  def time_management
    (total_attended.to_f/(total_questions.to_f.nonzero? || 1))*100
  end

  def self.total_accuracy
    (total_correct.to_f/total_attended.to_f).to_f.round(2)*100 rescue 0
  end

  def total_questions
    return l1_total + l2_total+ l3_total 
  end

  def find_rank
    total_marks = Report.where(exam_date:exam_date,user_id:user_id).sum(:total_mark).to_f
    total_questions = Report.where(exam_date:exam_date,user_id:user_id).total_questions.to_f
    (total_marks/(total_questions*4)).to_s
  end

  # event performance

  def self.event_performance(user) 
    h = {}
    collection = Report.where(school_id:user.school.id)
    start_date = collection.first.exam_date
    end_date = collection.last.exam_date
    students = User.where(role:"student", school_id:user.school.id).map{|e| e.id}
    while end_date >= start_date
      temp = {}
      students.each do |id|
        total_marks = Report.where(user_id:id,exam_date:end_date).sum(:total_mark).to_i
          temp[id] = total_marks
      end
      h[end_date] = temp.invert#.sort_by {|k,v| v}
      end_date = end_date - 1.days  
    end
    # return h
    # {
    #   {:title=>"", :start=> "", :end=> "", :recurring => false},
    #    {:title=>"", :start=> "", :end=> "", :recurring => false},
    #     {:title=>"", :start=> "", :end=> "", :recurring => false},
    #      {:title=>"", :start=> "", :end=> "", :recurring => false},
    #       {:title=>"", :start=> "", :end=> "", :recurring => false},
    #        {:title=>"", :start=> "", :end=> "", :recurring => false}
    # }
    has = []
    h.each do |k,v|
      v.each_with_index do |(key,value), index|
        if value == user.id
          rank = index + 1
          has << {:title=>"#{rank}/#{v.count}", :start=> "#{k}", :end=> "#{k}", :recurring => false}
        end  
      end
    end
    return has
    # p "--------------------"
    # p h
    # p "---------------"
    # h.each do |k,v|
    #   p "-----------------date"
    #   p k
    #   p "--------------value"
    #   v.each_with_index do |(key,value),index|

    #    p "user _id #{value} has rank #{index+1}"
     # end
      # p v.sort_by {|kn,v| v}.reverse!
    # end
    # p h.sort_by {|k,| v}.reverse!
  end
end
  