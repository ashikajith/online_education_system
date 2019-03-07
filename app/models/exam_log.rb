class ExamLog
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paranoia

  #fields
  field :exam_id
  field :user_id
  field :question_paper_id
  field :question_id
  field :time_taken, type:Integer
  field :answered
  field :attempt
  field :correct_option
  field :key
  field :correct_status, type:Boolean, default:false
  field :level
  field :mark, type:Integer, default:0

  #relations
  belongs_to :exam
  belongs_to :user
  belongs_to :question_paper
  belongs_to :question

  #validations
  validates_presence_of :exam_id, :user_id, :question_paper_id, :question_id

  scope :question_type_count, lambda{|type| where(level:type)}
  scope :answered, where(answered:{:$ne=>""})
  scope :correct, where(correct_status:true)

  def self.details(exam, user, hash_value, current_index)
    data = JSON.parse(hash_value["question"])
    question_id = data["_id"]["$oid"]
    question = Question.find(question_id)
    time_taken = hash_value["total_time"]
    answered = hash_value["answer"]
    attempted = hash_value["attempt"]
    if self.create(exam_id:exam.id, question_paper_id:exam.question_paper.id, user_id:user.id, correct_option:question.correct_option,
                question_id:question.id,time_taken:time_taken.to_i, answered:answered, attempt:attempted, level:question.level, key:current_index)
    else
      errors.add(:base, "Unable to save the Exam Log")
    end  
  end

  after_create :update_status

  def update_status
    if self.answered.to_s == self.correct_option.to_s
      self.update(correct_status:true, mark:4 )
    elsif self.answered != ""
      self.update(mark:-1)  
    end
  end

  def self.total_score
    sum(:mark)    
  end

  def total_score
    sum(:mark)
  end

  def status
    if self.answered != ""
      if self.correct_status
        return "Correct"
      else
        return "Incorrect"
      end
    else
      return "Not Attended"
    end        
  end
end
