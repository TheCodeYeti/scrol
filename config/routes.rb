Rails.application.routes.draw do

  root to: 'messages#index' 

  get 'mail/index'

  # added by paul start
  get 'oauth/redirect' #for testing
  # get 'authorize' => 'oauth#gettoken'
  get 'results/:provider', to: 'oauth#results', as: 'oauth_results' #@spencer to look at
  # added by paul end

  get 'twitter/index'

  resources :user_sessions #@spencer do we need this??
  resources :users
  resources :messages

  get 'messages/import/:user_id', to: 'messages#import', as: 'import_messages'

  get 'login' => 'user_sessions#new', as: :login
  post 'logout' => 'user_sessions#destroy', as: :logout

  get 'github/redirect_git'
  get 'github/callback_git'
  get 'github/results_git'

  get 'oauths/oauth'
  get 'oauths/callback'
  post 'oauths/callback'
  post "oauth/callback" => "oauths#callback"
  get 'oauth/callback_outlook' #@spencer look at this and make sure it's added in controller
  get "oauth/callback" => "oauths#callback"
  get "oauth/:provider" => "oauths#oauth", :as => :auth_at_provider

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
