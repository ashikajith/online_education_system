Eduportal::Application.routes.draw do

  mount Ckeditor::Engine => '/ckeditor'
  mathjax 'mathjax'
  root :to => "home#index"
  match "/learn" => 'home#learn', via: :get
  match "/features/knowledge_base" => 'home#knowledge_base_feature', via: :get
  match "/features/analytics" => 'home#analytics_feature', via: :get
  match "/features/personalized_learning" => 'home#personalized_learning', via: :get
  match "/faq" => 'home#faq', via: :get
  match "/privacy_policy" => 'home#privacy_policy', via: :get
  match "/terms_of_service" => 'home#terms_of_service', via: :get
  devise_for :users, :controllers => {:registrations => "registration"} do
    get "/users/load_fees" => "registration#load_fees"
  end
  namespace :portal do
    match '/dashboard' => 'dashboard#index', via: :get
    get '/dashboard/wall' => 'dashboard#wall'
    match '/dashboard/unauthorized' => 'dashboard#unauthorized', via: :get
    resources :schools
    match '/schools/display_question_sets' => 'schools#display_question_sets', via: :post
    match '/schools/submit_question_set' => 'schools#submit_question_set', via: :post
    resources :question_tags
    resources :subjects
    resources :schemes
    resources :units
    get '/institutions/schedule_exam'
    resources :institutions
    resources :questions
    match '/question_papers/submit_question' => 'question_papers#submit_question', via: :post
    match '/question_papers/view_details' => 'question_papers#view_details', via: :post
    resources :question_papers
    match '/question_sets/submit_question_paper' => 'question_sets#submit_question_paper', via: :post
    resources :question_sets
    match '/question_sets/attend' => 'question_sets#attend', via: :post
    
    post '/users/activate_account'
    match '/users/change_password' => 'users#change_password', via: :get
    match '/users/update_password' => 'users#update_password', via: :post
    match '/users/profile' => 'users#profile', via: :get
    match '/users/profile_edit' => 'users#profile_edit', via: :get
    match '/users/update_profile' => 'users#update_profile', via: :post
    resources :users
    match '/knowledgebase/vote' => 'knowledgebase#vote', via: :get
    match '/knowledgebase/vote_answer' => 'knowledgebase#vote_answer', via: :get
    match '/knowledgebase/load_unit_questions' => 'knowledgebase#load_unit_questions', via: :get
    get '/knowledgebase/reply' => 'knowledgebase#reply'
    match '/knowledgebase/submit_reply' => 'knowledgebase#submit_reply', via: [:post, :patch]
    get '/knowledgebase/approve_question' => 'knowledgebase#approve_question'
    resources :knowledgebase
    match '/exam/event_performance' => 'exam#event_performance', via: :get
    match '/exam/performance_list' => 'exam#performance_list', via: :get
    match '/exam/load_question' => 'exam#load_question', via: [:post, :get]
    match '/exam/complete_exam' => 'exam#complete_exam', via: :get
    match '/exam/load_prev_exams' => 'exam#load_prev_exams', via: :get
    match '/exam/unattended' => 'exam#unattended', via: :get
    resources :exam do
      collection { get :timer }
      collection { get :questions }
    end
    match '/notification/marked' => 'notification#marked', via: :post
    get '/analysis' => 'analysis#index'
    get '/analysis/time_management' => 'analysis#time_management'
    get '/analysis/proficiency' => 'analysis#proficiency'
    get '/analysis/accuracy' => 'analysis#accuracy'
    get '/analysis/timedistribution' => 'analysis#timedistribution'
    get '/analysis/strategy' => 'analysis#strategy'
    get '/message/sent' => 'message#sent'
    match '/message/reply/:id' => 'message#reply', via: :get
    match '/message/send_reply' => 'message#send_reply', via: :post
    match '/message/delete_thread/:id' => 'message#delete_thread', via: :delete
    resources :message
    resources :exam_schedule
    match '/library/subject_library' => 'library#subject_library', via: :get
    resources :library
    resources :course
  end

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.


  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
