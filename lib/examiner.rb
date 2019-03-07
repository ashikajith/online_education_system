module Examiner
  class ConductExam < Exam
    def self.setup exam, user, question_paper
      @exam = exam
      @user = user
      @question_paper = question_paper
      @exam.user_id = user.id
      @exam.school = user.school.id
      @exam.start_time = Time.now
      questions_count = @question_paper.questions.count
      @exam.end_time = @exam.start_time + questions_count*1.5.minutes
      @exam.subject_id = @question_paper.subject.id
      @exam.save
      @exam
    end

    def self.init_timer exam, user
      time_remaining = exam.end_time - exam.start_time
      while time_remaining > 0
        WebsocketRails[:"#{exam.id}"].trigger 'timer', time_remaining
        sleep 1
        time_remaining -=1
      end
      complete_exam(exam, user) if !user.exams.last.status
    end

    def self.publish_question_paper exam
      exam.question_paper.questions.each_with_index do |qp,index|
        q_index = exam.id.to_s + ":" + (index +1).to_s
        $redis.hmset(q_index, 'index', index+1, 'question', qp.to_json, 'options', qp.options.to_json, 'answer', '','status', "unseen", 'attempt', 0, 'start_time', '', 'end_time', '', 'total_time', '' , 'last', false)
      end
      first_index = exam.id.to_s + ":1"
      start_time = Time.now
      $redis.hmset(first_index, 'start_time', start_time, 'status',"seen")
      last_index = exam.id.to_s + ":#{exam.question_paper.questions.count}"
      $redis.hset(last_index, 'last', true)
      # init_timer exam, user
    end

    def self.complete_exam exam, user
      WebsocketRails[:"#{exam.id}"].trigger 'timer', 0
      exam.update(status:true)
      question_ids = exam.exam_logs.map{|e| e.question_id}
      exam.question_paper.questions.each_with_index do|qn,i|
        exam_hash = $redis.hgetall(exam.id.to_s + ":#{i+1}")
        current_index = exam.id.to_s + ":" + (i+1).to_s
        unless question_ids.include? qn.id
          save_values(exam, exam_hash, user, current_index)
        end
      end
      Report.create_report(exam, user)
      Notify::ExamSubmission.notify(user, exam.id)
    end

    def self.save_values (exam, hash_value, user, current_index=nil)
      data = JSON.parse(hash_value["question"])
      ExamLog.details(exam, user, hash_value, current_index )  
    end
  end
end
