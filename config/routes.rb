SampleApp::Application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :microposts, only: [:create, :destroy]
      resources :users, only: [] do
        member do
          get :microposts
          get :feeds
          get :search
        end
      end
    end
  end

  get '/foods/query', to: 'foods#query', as: :query_food
  get '/email_confirmation', to: 'users#confirm_email', as: :email_confirmation

  [:comment, :share].each do |collapse_type|
    get "/collapses/#{collapse_type}/:id", to: "collapses##{collapse_type}", as: "#{collapse_type}_collapse"
  end

  [:food, :share].each do |modal_type|
    get "/modals/#{modal_type}/:id", to: "modals##{modal_type}", as: "#{modal_type}_modal"
  end

  [:micropost, :food, :user].each do |action|
    get "/search/#{action}", to: "search##{action}", as: "search_#{action}"
  end

  get '/notices/count', to: 'notices#count'
  resources :notices, only: [:index]

  resources :users do
    member do
      get :following, :followers, :foods, :calorie
      get :send_confirm_email
      delete :avatar, to: "users#remove_avatar"
      patch :avatar
    end
  end
  resources :microposts, only: [:create, :destroy] do
    member do
      get :comments, :shares
    end
  end

  resources :passwords, only: [:create, :show]
  resources :sessions,      only: [:new, :create, :destroy]
  resources :likes, only: [:create, :destroy]
  resources :relationships, only: [:create, :destroy]
  resources :watches,       only: [:create, :destroy]

  root to: 'static_pages#home'
  match '/signup',  to: 'users#new',            via: 'get'
  match '/signin',  to: 'sessions#new',         via: 'get'
  match '/signout', to: 'sessions#destroy',     via: 'delete'
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
