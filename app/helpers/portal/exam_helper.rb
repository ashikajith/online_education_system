module Portal::ExamHelper
  def rank_cal(rank, parameter)
    case 
    when rank == 0.000000000000000
      color = "#757575"
    when rank <= (parameter[1] + parameter[0])
      color = "#C7E6F2"
    when rank >=  ((2*parameter[1]) + parameter[0])
      color = "#44bbdf"
    else
      color = "#70c9e5" 
    end     
  end  
end
