module FilterKnowledgebase
  class WithSubject < Knowledgebase

    def initialize subject_id, current_user=nil
      @subject = Subject.find(subject_id)
      @current_user = current_user
    end

    def latest
      @subject.knowledgebases.latest
    end

    def most_rated
      @subject.knowledgebases.rated
    end

    def unapproved
      @subject.knowledgebases.unapproved(@current_user)
    end

    def units
      @subject.units
    end
  end

  class WithUnit < Knowledgebase
    def initialize unit_id
      @unit = Unit.find(unit_id)
    end

    def all
      @unit.knowledgebases.published
    end

    def related
      @unit.knowledgebases.published.order_by(:created_at => :desc)
    end
  end 
end