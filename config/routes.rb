WebApp::Application.routes.draw do


  devise_for :school_admins,:controllers => {:sessions => 'school_sessions'}

  devise_for :users,:controllers => {:sessions => 'sessions'}
  devise_scope :user do
    get "sign_out", :to => "devise/sessions#destroy",:as => "logout"
  end

  devise_for :admins,:controllers => {:sessions => "admin/sessions",:passwords => "admin/passwords"}
  devise_scope :admin do
    get "admin_login",:to => "admin/sessions#new" ,:as => "admin_login"
    get "admin_sign_out", :to => "admin/sessions#destroy",:as => "admin_logout"
  end

  namespace :admin do
    resources :dashboards
    resources :schools
    resources :students do
      member do
        get :followers
        get :following
      end
    end
  end

  resources :schools do
    resources :students
    resources :teachers
    resources :upload_csvs do
      collection do
        post :upload_csv
      end
    end
  end

  resources :profiles do
    member do
      get :profile_summary
      get :more_profile_information
      get :followers
      get :following
    end
    collection do
      get :edit_password
      put :update_password
      get :invite
      post :invitation
    end
  end

  resources :users do
    resources :posts do
      collection do
        post :repost
        post :favourite
        put :update_favourite
        put :update_mark_favourite
      end
    end
    resources :follows do
      member do
        post :follow
        put :unfollow
        put :update_follow
      end
    end
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
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
  root :to => 'home#index'
end