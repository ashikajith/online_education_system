module Notify
  class SubjectMentors < Notification
    def self.notify obj, message = "A new question has been posted in knowledgebase"
      mentors = obj.subject.users
      mentors.each do |mentor|
        @notification = Notification.create(user_id:mentor.id, event_name:"knowledgebase", event_id: obj.id, message: message)
      end
      WebsocketRails[:notification].trigger 'new', @notification.to_json
    end
  end

  class ExamSubmission < Notification
    def self.notify user, exam_id
      question_paper_name = Exam.find(exam_id).question_paper.name
      notification = Notification.create(user_id:user.id, event_name:"exam", event_id: exam_id, message: "Results for #{question_paper_name} has been published.")
      WebsocketRails[:notification].trigger 'new', notification.to_json
    end
  end
end