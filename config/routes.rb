Attendance::Application.routes.draw do
  resources :users
  match 'login',           :to => "users#login",              :as => "login"
  match 'verify_login',    :to => "users#verify_login",       :as => "verify_login"
  match 'logout',          :to => "users#logout",             :as => "logout"
  match 'forgot-password', :to => "users#forgot_password",    :as => "forgot_password"
  match 'check-password',  :to => "users#password_check",     :as => "password_check"
  match 'report',          :to => "report#show_history",      :as => "show_history"
  match 'find-user',       :to => "report#find_user_email",   :as => "find_user_email"
  match 'show-user',       :to => "report#show_user_history", :as => "show_user_history"
  match 'specific-search', :to => "report#search_by_date",    :as => "search_by_date"

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
   root :to => 'home#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
