class LeaderBoard
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paranoia

  #fields

  field :rank
  field :total_users_attended
  field :accuracy
  field :l1_attended
  field :l2_attended
  field :l3_attended
  field :exam_date, type:Date
  field :total_mark
  field :least_mark_ratio
  field :l1_total
  field :l2_total
  field :l3_total
  field :mark_ratio
  field :day_parameter

  #explanation
  # day_parameter 
  # Is the day parameter of an exam on that day, this value + the value of the least mark scored by the student on that day
  # is considered as the limit that assigns the color band for the student  
  
  #mark_ratio
  #The mark ratio of a corresponding student in the exam 
  # mark ratio is calclulated as total scored mark by a student / the total mark of the paper
  # example there is 8 questions in an exam and the scored mark of a student is 16
  #then mark ratio = 16/8*4 = 16/32 = 0.5 is the mark ratio

  #least mark_ratio
  #this is to find the minimum value of mark ratio scored by a student on that day of exam

  #associaition

  belongs_to :user
  belongs_to :school
  belongs_to :exam_schedule
  belongs_to :exam

  #Method to update the leaderboard based on school and a date's exams
  #This method will be called using a scheduled task everyday
  def self.update_leaderboard
    date = Date.today - 1.days
    School.all.each do |school|
      User.where(role:"student",school_id:school.id).each do |s|
        unless Report.where(exam_date:date, school_id:school.id, user_id:s.id).empty?
          l1_attended = Report.where(exam_date:date, school_id:school.id, user_id:s.id).sum(:l1_attended)
          l2_attended = Report.where(exam_date:date, school_id:school.id, user_id:s.id).sum(:l2_attended)
          l3_attended = Report.where(exam_date:date, school_id:school.id, user_id:s.id).sum(:l3_attended)
          l1_total = Report.where(exam_date:date, school_id:school.id, user_id:s.id).sum(:l1_total)
          l2_total = Report.where(exam_date:date, school_id:school.id, user_id:s.id).sum(:l2_total)
          l3_total = Report.where(exam_date:date, school_id:school.id, user_id:s.id).sum(:l3_total)
          accuracy = Report.where(exam_date:date, school_id:school.id, user_id:s.id).accuracy
          total_mark = Report.where(exam_date:date,school_id:school.id, user_id:s.id).sum(:total_mark)
          mark_ratio = ((total_mark).to_f/((l1_total+l2_total+l3_total)*4).to_f) rescue 0

          LeaderBoard.create!(exam_date:date, accuracy:accuracy, l1_attended:l1_attended, 
            l2_attended:l2_attended, l3_attended:l3_attended, user_id:s.id, school_id:school.id, total_mark:total_mark,
            l1_total:l1_total, l2_total:l2_total,l3_total:l3_total, mark_ratio:mark_ratio)
        end
      end
      unless LeaderBoard.where(exam_date:date).empty?
        ary = school.leader_boards.desc(:total_mark).desc(:accuracy).where(exam_date:date).map{|e| [e.total_mark, e.accuracy] }.compact
        count = ary.count rescue 0
        school.leader_boards.desc(:total_mark).desc(:accuracy).where(exam_date:date).map{|e| e.update(rank:((ary.rindex([e.total_mark, e.accuracy]) +1 rescue 0)), total_users_attended:count) }
      #may need to run this code if the rank comes same for more than one students
      # that is the case which students score same marks eith same accuracy
      
      # school.leader_boards.asc(:rank).desc(:accuracy).each_with_index do |lb,index|
      #   lb.update(rank:index + 1)
      # end

      # need to modify, try to query once to get the two parameters
        value = school.leader_boards.where(exam_date:date).map(&:mark_ratio).minmax
        limit = (value[1] - value[0]).to_f/3 rescue 0
        least_mark_ratio = LeaderBoard.where(exam_date:date, school_id:school.id).asc(:mark_ratio).first.mark_ratio
        LeaderBoard.where(exam_date:date, school_id:school.id).map{|e| e.update(day_parameter:limit, least_mark_ratio:least_mark_ratio)}
      end
    end
  end

  #Overriding the default json method so that the data returned can be used for plotting full-calendar
  def as_json(options = {})
    {
      :title => "#{self.user_id}",
      # :desctiption => "#{self.rank}"
      :start => self.exam_date.rfc822,
      :end => self.exam_date.rfc822,
      :recurring => false,
      :allDay => true,
      :rank => self.rank,
      :total => self.total_users_attended,
      :l1_attended => self.l1_attended,
      :l2_attended => self.l2_attended,
      :l3_attended => self.l3_attended,
      :l1_total => self.l1_total,
      :l2_total => self.l2_total,
      :l3_total => self.l3_total,
      :accuracy => self.accuracy,
      :mark_ratio => self.mark_ratio,
      :least_mark_ratio => self.least_mark_ratio,
      :day_parameter => self.day_parameter,
      :backgroundColor => color_pick
    }
  end

  # this method is called for populating the fullcalendar datas
  def self.event_performance user, school_id=nil
    leader_boards = user.leader_boards if user.student?
    leader_boards = user.school.leader_boards if user.sadmin? || user.sstaff?
    leader_boards = LeaderBoard.where(school_id:school_id) unless school_id.nil?
    leader_boards ||= LeaderBoard.all
  end

  #this method will be called for each events in the full calendar 

  def color_pick
    if mark_ratio < (day_parameter + least_mark_ratio)
      color = "#C7E6F2" #light color below average performance
    elsif mark_ratio >= ((2*day_parameter) + least_mark_ratio)
      color = "#44bbdf" #dark color excellent perfomance
    else
      color = "#70c9e5" #meduim color average performance
    end    
    return color      
  end

  #this method is to find the minimum value of mark ratio scored by a student on that day of exam
  # and the limit ratio of the corresponding exam of that dat

  def self.overall_performance school_id=nil
    overall_array = []
    overall_mark_ratio = []
    User.where(role:"student").each do |user|
      overall_mark_ratio << user.leader_boards.sum(:mark_ratio)
    end
    value = overall_mark_ratio.minmax
    limit = (value[1] - value[0]).abs.to_f/3 rescue 0
    overall_array << value[0] << limit
    return overall_array
  end
end

