class Portal::AnalysisController < ApplicationController
  layout 'analysis'
  before_filter :authenticate_user!
  load_and_authorize_resource :class => "Report"
  require 'plot_graph'


  def index
    
  end

  #Time management = no of questions attended by no of total questions in %
  #Personal best is the highest % of questions attended ever by the user
  #learning curve %increase in attended questions of current week and current month compared to previous week and previous month respectively
  def time_management
    @personal_best = current_user.reports.map(&:time_management).max.round(2) rescue 0
    @personal_best = "#{@personal_best}% Questions Attended"
    learning_curve 'time_management'
    data_presenter 'time_management'
  end

  #Ratio of L1 attended questions to L2 attended questions to L3 questions attended
  #Personal best is obtained calculating the highest value obtained using eqn ((L1-attended/L1-total)*100 + (L2-attended/L2-total)* 10 (L3-attended/L3-total))
  def strategy
    temp = {}
    #format temp[L1:L2:L3] = index
    current_user.reports.each do |report|
      l1 = (report.l1_attended.to_f/(report.l1_total.to_f.nonzero? || 1 ))*100
      l2 = (report.l2_attended.to_f/(report.l2_total.to_f.nonzero? || 1 ))*100
      l3 = (report.l3_attended.to_f/(report.l3_total.to_f.nonzero? || 1 ))*100
      temp["#{l1}:#{l2}:#{l3}"] = (report.l1_attended.to_f/report.l1_total.to_f)*100 +  (report.l2_attended.to_f/report.l2_total.to_f)*10 +  (report.l3_attended.to_f/report.l3_total.to_f)
    end
    best = temp.max[0]
    @personal_best = "L1 : " + best.split(":")[0].to_s + "% " + "L2 : " + best.split(":")[1].to_s + "% " + "L3 : " + best.split(":")[2].to_s + "% "
    learning_curve_strategy
    data_presenter_new 'attended'
  end

  #Accuracy: ratio of total correct questions to total attended questions in %
  #Personal best is the highest accuracy ever achieved by the user
  #Learning curve is %increase in accuracy of current week and current month compared to previous week and previous month respectively
  def accuracy
    @personal_best = current_user.reports.map(&:accuracy).max.round(2) rescue 0
    learning_curve 'accuracy'
    data_presenter 'accuracy'
  end

  def timedistribution
    temp = []
    current_user.reports.each do |report|
    end
    @personal_best = temp.max
    data_presenter_new 'time'
  end

  #Proficiency: Proficiency is calculated on unit basis with 2 factors, total attended questions and accuracy
  #Units having highest questions attended in % will have high proficiency factor and if the value is same then accuracy factor is used for further sorting
  def proficiency
    h = {}
    subjects = current_user.scheme.subjects
    if request.xhr?
      if params[:subject_id]
        subjects = Subject.where(id:params[:subject_id]) unless params[:subject_id].blank?
      end
    end  
    subjects.each do |sub|
      sub.units.each do |u|
        if u.reports.exists?       
          accuracy = ((u.reports.where(user_id:current_user.id).total_correct.to_f/u.reports.where(user_id:current_user.id).total_questions.to_f).to_f*100).round(2)
          attended = ((u.reports.where(user_id:current_user.id).total_attended.to_f/u.reports.where(user_id:current_user.id).total_questions.to_f).to_f*100).round(2)
          data = []
          u.reports.where(user_id:current_user.id).each do |report|
            l1 = (report.l1_attended.to_f/(report.l1_total.to_f.nonzero? || 1 ))*100
            l2 = (report.l2_attended.to_f/(report.l2_total.to_f.nonzero? || 1 ))*100
            l3 = (report.l3_attended.to_f/(report.l3_total.to_f.nonzero? || 1 ))*100
            data << (report.l1_attended.to_f/report.l1_total.to_f)*100 +  (report.l2_attended.to_f/report.l2_total.to_f)*10 +  (report.l3_attended.to_f/report.l3_total.to_f)
          end
          strategy = average(data)
          h[u.name] = [attended, accuracy, strategy]
        else
          h[u.name] = [0,0,0]
        end
      end
    end
    @hash = h.sort_by {|k,v| v}.reverse! 
  end

  private
  #Learning curve: comparison of current weeks data and current months data with previous weeks and previous months data respectively
  #The comparison factor for this method will be either 'time_management' or 'accuracy'
  def learning_curve factor
    @learning_curve = []
    current_week_data = current_user.reports.where(exam_date:(Time.now.all_week())).map {|x| x.send(:"#{factor}")}
    prev_week_data = current_user.reports.where(exam_date:((Time.now-1.week).all_week())).map {|x| x.send(:"#{factor}")}
    @learning_curve << (average(current_week_data) - average(prev_week_data)).round(2)
    current_month_data = current_user.reports.where(exam_date:(Time.now.all_month())).map {|x| x.send(:"#{factor}")}
    prev_month_data = current_user.reports.where(exam_date:((Time.now-1.month).all_month())).map {|x| x.send(:"#{factor}")}
    @learning_curve << (average(current_month_data) - average(prev_month_data)).round(2)
    @learning_curve = [0,0] if @learning_curve.empty?
  end

  #Learning curve for calculating strategy
  #%change in strategy from current week and current month compared to previous week and previous month respectively
  def learning_curve_strategy
    @learning_curve = []
    current_week_data = strategy_stats (Time.now.all_week())
    prev_week_data = strategy_stats ((Time.now-1.week).all_week())
    prev_month_data = strategy_stats ((Time.now-1.month).all_month())
    current_month_data = strategy_stats (Time.now.all_month())
    @learning_curve << (average(current_week_data) - average(prev_week_data)).round(2)
    @learning_curve << (average(current_month_data) - average(prev_month_data)).round(2)
  end

  #returs strategy statistics for current user over a date range
  def strategy_stats date_range
    data = []
    current_user.reports.where(exam_date:date_range).each do |report|
      l1 = (report.l1_attended.to_f/(report.l1_total.to_f.nonzero? || 1 ))*100
      l2 = (report.l2_attended.to_f/(report.l2_total.to_f.nonzero? || 1 ))*100
      l3 = (report.l3_attended.to_f/(report.l3_total.to_f.nonzero? || 1 ))*100
      data << (report.l1_attended.to_f/(report.l1_total.to_f.nonzero? || 1 ))*100 +  (report.l2_attended.to_f/(report.l2_total.to_f.nonzero? || 1 ))*10 +  (report.l3_attended.to_f/(report.l3_total.to_f.nonzero? || 1 ))
    end
    return data
  end

  #This method is used for filtering out data to time_management and accuracy
  #Initially the search method is called which returns a collection of reports based on filters from the view such as year, subject, duration.
  #This collection is passed along with the factor('time_management' or 'accuracy') for retrieving data for plotting graph
  def data_presenter factor
    collection = search
    data_collector collection, factor, params[:duration]
    if request.xhr?
      render partial: 'graph' and return
    end
  end

  #This method would be called from data_presenter method, with inputs being the collection of reports and a factor for calculating analysis stats
  #calculates the anaysis stat based on the factor, for current user and for a comparison of current user with students of the same school
  #If a particular day has more than one exam then the average is taken, the factors would be time management and accuracy
  def data_collector collection, factor, duration
    your_data, comparison_data = [], [], []
    uniq_exam_dates = collection.map(&:exam_date).uniq
    if duration == "12"
      Date.today.month.times do |count|
        your_temp_data, todays_data = [], []
        collection.where(exam_date:(Time.now-count.month).all_month()).each do |report|
          your_temp_data << report.send(:"#{factor}")
        end
        Report.where(exam_date: (Time.now-count.month).all_month(), school_id:current_user.school.id).each do |m|
          todays_data << (m.send(:"#{factor}")).round(2) rescue 0
        end
        comparison_data << average(todays_data)
        your_data << average(your_temp_data)
      end
    else
      uniq_exam_dates.each do |date|
        your_temp_data,todays_data = [], []
        collection.where(exam_date:date).each do |report|
          your_temp_data << report.send(:"#{factor}")
        end
        Report.where(exam_date:date, school_id:current_user.school.id).each do |m|
          todays_data << (m.send(:"#{factor}")).round(2) rescue 0
        end
        comparison_data << average(todays_data)
        your_data << average(your_temp_data)
      end
    end
    your_data.reverse!
    comparison_data.reverse!
    factor == "accuracy" ? plot_accuracy(your_data, comparison_data) : plot_time_management(your_data, comparison_data)
  end

  #This method is used for filtering out data to time_distribution
  #Initially the search method is called which returns a collection of reports based on filters from the view such as year, subject, duration.
  #This collection is passed along with the factor('attended') for retrieving data for plotting graph
  def data_presenter_new factor
    collection = search
    default_data collection, factor
    if request.xhr?
      render partial: 'graph' and return
    end
  end

  #This method would be called from data_presenter_new method, with inputs being the collection of reports and a factor for calculating analysis stats
  #calculates the anaysis stat based on the factor, for current user and for a comparison of current user with students of the same school
  #If a particular day has more than one exam then the average is taken, the factors would be attended
  def default_data collection, factor
    your_data, comparison_data, l1_data, l2_data, l3_data = [], [], [], [], []
    average_l1_comp_data, average_l2_comp_data, average_l3_comp_data = [],[],[]
    duration = params["duration"]
    uniq_exam_dates = collection.map(&:exam_date).uniq
    if duration == "12"
      Date.today.month.times do |count|
        l1_temp_data, l2_temp_data, l3_temp_data = [], [], []
        collection.where(exam_date:(Time.now-count.month).all_month()).each do |r|
          l1_temp_data << r.send(:"l1_#{factor}")
          l2_temp_data << r.send(:"l2_#{factor}")
          l3_temp_data << r.send(:"l3_#{factor}")
        end
        l1_comp_data, l2_comp_data, l3_comp_data = [], [], []     
        Report.where(exam_date: (Time.now-count.month).all_month(), school_id:current_user.school.id).each do |m|
          l1_comp_data << m.send(:"l1_#{factor}")
          l2_comp_data << m.send(:"l2_#{factor}")
          l3_comp_data << m.send(:"l3_#{factor}")
        end
        l1_data << average(l1_temp_data)
        l1_data.reverse!
        l2_data << average(l2_temp_data)
        l2_data.reverse!
        l3_data << average(l3_temp_data)
        l3_data.reverse!
        average_l1_comp_data << average(l1_comp_data)
        average_l1_comp_data.reverse!
        average_l2_comp_data << average(l2_comp_data)
        average_l2_comp_data.reverse!
        average_l3_comp_data << average(l3_comp_data)
        average_l3_comp_data.reverse!
      end
    else
      uniq_exam_dates.each do |date|
        l1_temp_data, l2_temp_data, l3_temp_data = [], [], []
        collection.where(exam_date:date).each do |r|
          l1_temp_data << r.send(:"l1_#{factor}")
          l2_temp_data << r.send(:"l2_#{factor}")
          l3_temp_data << r.send(:"l3_#{factor}")
        end
        l1_comp_data, l2_comp_data, l3_comp_data = [], [], []     
        Report.where(exam_date: date, school_id:current_user.school.id).each do |m|
          l1_comp_data << m.send(:"l1_#{factor}")
          l2_comp_data << m.send(:"l2_#{factor}")
          l3_comp_data << m.send(:"l3_#{factor}")
        end
        l1_data << average(l1_temp_data)
        l2_data << average(l2_temp_data)
        l3_data << average(l3_temp_data)
        average_l1_comp_data << average(l1_comp_data)
        average_l2_comp_data << average(l2_comp_data)
        average_l3_comp_data << average(l3_comp_data)
      end
    end
    your_data = [l1_data, l2_data, l3_data]
    comparison_data = [average_l1_comp_data, average_l2_comp_data, average_l3_comp_data]
    factor == "time" ? plot_timedistribution(your_data, comparison_data) : plot_strategy(your_data, comparison_data)
  end

  #query the reports model based on filters from the view such as year, subject, duration
  #a search_hash would be generated on calling the search_hash method which is used for query
  def search
    year = params[:year] ||= {}
    params[:duration] = "30" if params[:duration].nil?
    duration = params[:duration]
    subject_id = params[:subject_id] ||= {}
    query = search_hash year, subject_id
    reports = current_user.reports.desc(:exam_date).where(query).where(exam_date:Time.now.all_week()) if (duration == "7")
    reports = current_user.reports.desc(:exam_date).where(query).where(exam_date:Time.now.all_month()) if (duration == "30")
    reports = current_user.reports.desc(:exam_date).where(query).where(exam_date:Time.now.all_year()) if (duration == "12")
    return reports
  end

  #generate a search hash based on the params from the view
  def search_hash year, subject_id
    hash = {}
    hash[:year] = year unless year.empty?
    hash[:subject_id] = subject_id unless subject_id.empty?
    hash[:school_id] = current_user.school.id if current_user.student?
    return hash
  end

  #Plot the time management column graph
  #input would be current users data and event average 
  def plot_time_management(your_data=nil, comparison_data=nil)
    @yours = PlotGraph::Graphs.column 'attended question', your_data, "Performance over the days", "Questions attempted %"
    @comparison = PlotGraph::Graphs.bar 'Your score', 'Event Average', your_data, comparison_data, "Performance over the days", "Questions attempted" 
    @comparison = [@comparison]
  end

  #Plot the strategy stacked percentage graph
  #input would be current users data and event average 
  def plot_strategy(data,compare_data)
    your_color = ['#C7E6F2','#70D2E5', '#44BBDF']
    name = ['L1 Questions', 'L2 Questions', 'L3 Questions']
    comparison_color = ['#D9D9D9', '#B2B2B2', '#8C8C8C']
    @yours = PlotGraph::Graphs.percentage name, data, your_color, "Strategy over the days", "No of questions attended"
    @yours_compare = PlotGraph::Graphs.percentage name, data, your_color, 200, "Strategy over the days", "No of questions attended"
    @comparison = PlotGraph::Graphs.percentage name, compare_data, comparison_color, 200, "Strategy over the days", "No of questions attended"
    @comparison = [@yours_compare, @comparison]
  end

  #Plot the time accuracy column graph
  #input would be current users data and event average 
  def plot_accuracy(your_accuracy, compare_accuracy)
    @yours = PlotGraph::Graphs.column 'Correct questions', your_accuracy, "Performance over the days", "No of correct questions"
    @comparison = PlotGraph::Graphs.bar 'Your score', 'Event Average', your_accuracy, compare_accuracy, "Performance over the days", "QNo of correct questions" 
    @comparison = [@comparison] 
  end

  #Plot the time distribution column graph
  #input would be current users data and event average 
  def plot_timedistribution( your_data, compare_data )
    your_color = ['#C7E6F2','#70D2E5', '#44BBDF']
    name = ['Time L1 Questions', 'Time L2 Questions', 'Time L3 Questions']
    comparison_color = ['#D9D9D9', '#B2B2B2', '#8C8C8C']
    @yours = PlotGraph::Graphs.percentage name, your_data, your_color, "Time distribution over the days", "No of questions attended"
    @yours_compare = PlotGraph::Graphs.percentage name, your_data, your_color, 200, "Time distribution over the days", "No of questions attended"
    @comparison = PlotGraph::Graphs.percentage name, compare_data, comparison_color, 200, "Time distribution over the days", "No of questions attended"
    @comparison = [@yours_compare, @comparison]
  end

  def average(array)
    return (array.sum/array.count).to_f.round(2) rescue ZeroDivisionError;0
  end
end
