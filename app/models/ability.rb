class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    case user.role
      #Owner
      when "owner"
        can :manage, :all

      #Institution Admin
      when "iadmin"
        can [:read, :edit, :update], Institution, :id => user.institution.id
        can :manage, School, :institution_id => user.institution.id
        can :manage, User, :institution_id => user.institution.id
        can :manage, [Subject, Scheme, Unit, Question, QuestionPaper, QuestionSet, QuestionTag, Knowledgebase]
        can :manage, Message, institution_id: user.institution.id
        can [:manage], Notification, :user_id => user.id
        can [:index, :read, :event_performance], Exam
        can :manage, Library
        cannot :manage, Report
        can :manage, ExamSchedule
        can :manage, Course
      #Institution Staff
      when "istaff"
        can [:read, :edit, :update], Institution, :id => user.institution.id
        can :manage, School, :institution_id => user.institution.id
        can :manage, User, :institution_id => user.institution.id
        can :manage, [Subject, Scheme, Unit, Question, QuestionPaper, QuestionSet, QuestionTag, Knowledgebase]
        can [:read,:update], Notification, :user_id => user.id
        can :manage, Message, institution_id: user.institution.id
        can :manage, Notification, :user_id => user.id
        can [:index, :read, :event_performance], Exam
        can :manage, Library
        cannot :manage, Report
        can :manage, ExamSchedule
        can :manage, Course
      #School Admin
      when "sadmin"
        can [:read, :edit, :update], School, :id => user.school.id
        can :manage, User, :school_id => user.school.id
        can :read, [Unit, Scheme, Knowledgebase]
        can [:index, :read, :event_performance], Exam, :school_id => user.school_id
        can :read, QuestionSet, :school_id=> user.school.id
        can :manage, Message, school_id: user.school.id
        can :manage, Notification, :user_id => user.id
        cannot :manage, Report
        can :read, Library
        cannot :manage, ExamSchedule
      #School Staff
      when "sstaff"
        can [:read, :edit, :update], School, :id => user.school.id
        can :manage, User, :school_id => user.school.id
        can :read, [Unit, Scheme, Knowledgebase]
        can [:index, :read, :event_performance], Exam, :school_id=> user.school.id
        can :read, QuestionSet, :school_id=> user.school.id
        can :manage, Message, school_id: user.school.id
        can :manage, Notification, :user_id => user.id
        cannot :manage, Report
        can :read, Library
        cannot :manage, ExamSchedule
      #Mentor
      when "mentor"
        can :manage, User, id: user.id
        can [:read], User, :institution_id => user.institution.id
        can :read, Scheme
        can :manage, [Unit, Question, QuestionPaper], :subject_id => user.subject.id
        can :manage, [QuestionSet, QuestionTag]
        #OPTIMIZE ability for kb as mentor
        can [:manage,:index], Knowledgebase, :subject_id => user.subject.id
        can [:index, :read], Exam, :subject_id=> user.subject.id
        can :manage, Message, user_id: user.id
        can :manage, Notification, :user_id => user.id
        can :read, Library, :subject_id=> user.subject.id
        cannot :manage, Report
        cannot :manage, ExamSchedule
      #Student
      when "student"
        if user.status? && user.course.online_status?
            can :manage, User, :id => user.id
            can :read, Unit, year: user.year
            can :read, Scheme
            can :manage, Knowledgebase, user_id: user.id
            can :read, Knowledgebase
            cannot [:reply,:approve_question], Knowledgebase
            can :manage, Exam, user_id: user.id
            cannot :destroy, Exam
            can :manage, Message, user_id: user.id
            can :read, Message, receiver_id: user.id
            can :manage, Message, receiver_id: user.id
            can :manage, Notification, :user_id => user.id
            if user.year == 'second'
                can [:index, :read, :subject_library], Library
            else
                can [:index, :read,:subject_library], Library, year: user.year
            end
            can :manage, Report
            cannot :manage, ExamSchedule
        else
            can :manage, User, :id => user.id
        end
      end
  end
end
