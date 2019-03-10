#Home Controller
class HomeController < ApplicationController
  layout 'log_in'
  def index
    if user_signed_in?
      redirect_to portal_dashboard_path
    else
      redirect_to new_user_session_path
    end
  end

  def learn
    
  end

  def knowledge_base_feature
    
  end

  def analytics_feature
    
  end

  def personalized_learning
    
  end

  def faq
    
  end

  def terms_of_service
    
  end

  def privacy_policy
    
  end
  
end
