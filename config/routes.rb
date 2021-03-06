Rails.application.routes.draw do

  #Erros 404 and 500 custom pages
  get "/404" => "errors#not_found"
  get "/500" => "errors#internal_server_error"

  # You can have the root of your site routed with "root"
  root 'welcome#index'

  #get 'users/index'
  
  get '/contact', to: 'users#contact_form',as: :contact
  post '/contact_message', to: 'users#contact_message',as: :contact_message
  
  scope :admin do
    get '/users', to: 'administration#users',as: :admin_users
    get '/ingredients', to: 'administration#ingredients',as: :admin_ingredients
    get '/containers', to: 'administration#containers',as: :admin_containers
    get '/recipes', to: 'administration#recipes',as: :admin_recipes
    get '/variants', to: 'administration#variants',as: :admin_variants
    get '/products', to: 'administration#products',as: :admin_products
  end

  #devise_for :users
  devise_for :users, :controllers => { registrations: 'registrations' }
  #scope "/admin" do
  resources :users
  #end
  #devise_scope :user do
  #  match '/sign-in' => "devise/sessions#new", :as => :login, via: :get
  #end

   resources :ingredient_types do
     resources :container_references
   end

   resources :ingredients do
     resources :containers do
       match '/update_with_mass', to: 'containers#update_with_mass', via: :patch
     end
   end

  resources :recipes do
    #get '/delete_list', to: 'recipes#delete_list', as: 'delete_list'

    resources :variants do
      match '/duplicate', to: 'variants#duplicate', via: :post
      match '/change_ingredients_edit', to: 'variants#change_ingredients_edit', via: :get
      match '/change_ingredients', to: 'variants#change_ingredients', via: :patch
      match '/change_proportions_edit', to: 'variants#change_proportions_edit', via: :get
      match '/change_proportions', to: 'variants#change_proportions', via: :patch
      match '/update_proportions', to: 'variants#update_proportions', via: :patch
      match '/normalize_proportions', to: 'variants#normalize_proportions', via: :patch# , as: 'update_proportion'
    end

    match '/duplicate_variant', to: 'recipes#duplicate_variant', via: :get

    resources :products

  end

  resources :recipe_types

  #get 'welcome/index'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):

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
