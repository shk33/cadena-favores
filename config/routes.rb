Rails.application.routes.draw do
  #Landing page route
  namespace :site, :path => "" do
    root 'site#index'
  end

  #Pusher Auth
  post 'pusher/auth'
  
  #Sessions
  get    'login'  => 'sessions#new'
  post   'login'  => 'sessions#create'
  delete 'logout' => 'sessions#destroy'

  #Signup
  get  'signup'  => 'users#new'
  post 'signup'  => 'users#create'


  # NO TOCAR LO DE ARRIBA
  #Main app Routes AGREGAR AQUI SUS RUTAS
  scope '/app' do
    root 'home#index'

    #Relationships
    resources :relationships , only: [:create, :destroy]
    match '/users/:id/following', to: 'users#following', via: "get", as: :following
    
    #Current user Settings
    match '/settings',      to: 'users#settings',   via: "get", as: :settings

    #Notifications
    resources :activities, only: [:show]
    match '/notifications', to: 'activities#index', via: "get", as: :notifications

    #Users
    resources :users do
      resources :profiles, only: [:update]
      member do
        get :following
      end
    end    
    match '/my_profile', to: 'users#my_profile', via: "get", as: :my_profile

    #Service Requests
    match '/my_service_requests', to: 'service_requests#user_index', via: "get", as: :my_service_requests
    resources :service_requests do
      resources :offers, only: [:create, :destroy] do
        member do 
          match '/accept',   to: 'offers#new_accept', via: "get",    as: :new_accept
          match '/accept',   to: 'offers#accept',     via: "post",   as: :accept
          match '/cancel',   to: 'offers#cancel',     via: "delete", as: :cancel
        end
      end
    end

    #Service Arangements
    match '/my_hired_requests',  to: 'service_arrangements#hired', via: "get", as: :my_hired_requests
    match '/my_hired_completed', to: 'service_arrangements#hired_completed', via: "get", as: :my_hired_completed
    match '/my_services_to_do', to: 'service_arrangements#index', via: "get", as: :my_services_to_do
    match '/my_calendar',        to: 'service_arrangements#calendar', via: "get", as: :my_calendar
    resources :service_arrangements, only: [:update, :show, :index] do
      resources :reviews
    end
  end

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
