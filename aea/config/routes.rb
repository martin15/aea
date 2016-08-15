Rails.application.routes.draw do


  devise_for :users, :controllers => { registrations: 'registrations' }
  resource :user, only: [:edit] do
    collection do
      patch 'update_password'
      get 'register_event'
      patch 'save_register_event'
      get 'update_price'
    end
  end

  get "users" => "users/dashboard#index", as: 'users'
  get "admin" => "admin/dashboard#index", as: 'admin'

  namespace :users do
    #get 'pick_up_schedule' => 'pick_up_schedule#index', :as => "pick_up_schedule"
    get 'pick_up_schedule/edit' => 'pick_up_schedule#edit', :as => "edit_pick_up_schedule"
    put 'pick_up_schedule/update' => 'pick_up_schedule#update', :as => "update_pick_up_schedule"
    get "registrants/total_price" => 'registrants#total_price'
    resources :payment_confirmations, :only => [:new, :create]
    resources :registrants
    resources :tickets, :only => [:edit, :update]
    get 'update_price_by_country' => "registrants#update_price_by_country"
  end

  namespace :admin do
    resources :countries
    resources :payment_confirmations, :only => [:index]
    get "payment_confirmations/:id/confirm" => "payment_confirmations#confirm", :as => "payment_confirmations_user_confirm"
    post "payment_confirmations/:id/save_confirmed" => "payment_confirmations#save_confirmed", :as => "payment_confirmations_save_user_confirmed"
    get "pick_up_schedules/download_schedule_report" => "pick_up_schedules#download_schedule_report", :as => "download_schedule_report"
    resources :pick_up_schedules
    resources :room_types
    resources :shuttle_buses
    get "shuttle_buses/:id/export_as_xls" => "shuttle_buses#export_as_xls", :as => "shuttle_bus_export_as_xls"
    get "users/:country_permalink/list" => "users#index", :as => "users_by_country"
    get "users/order_by/:order_by" => "users#order_by", :as => "users_order_by"
    get "users/:id/confirm" => "users#confirm", :as => "user_confirm"
    get "users/user_rooms" => "users#user_rooms", :as => "user_rooms"
    get "users/user_rooms/:room_type" => "users#user_rooms", :as => "user_rooms_by_type"
    get "users/confirmed_users" => "users#confirmed_users", :as => "user_confirmed_users"
    get "users/validate/:id" => "users#validate_user", :as => "user_validate_user"
    get "users/edit_confirmed/:id" => "users#edit_confirmed_user", :as => "edit_confirmed"
    post "users/:id/save_confirmed" => "users#save_confirmed", :as => "save_user_confirmed"
    resources :users
    resources :user_types

  end
  root 'home#index'
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
