# == Route Map
#
#                   Prefix Verb   URI Pattern                            Controller#Action
#         new_user_session GET    /users/sign_in(.:format)               devise/sessions#new
#             user_session POST   /users/sign_in(.:format)               devise/sessions#create
#     destroy_user_session GET    /users/sign_out(.:format)              devise/sessions#destroy
#            user_password POST   /users/password(.:format)              devise/passwords#create
#        new_user_password GET    /users/password/new(.:format)          devise/passwords#new
#       edit_user_password GET    /users/password/edit(.:format)         devise/passwords#edit
#                          PATCH  /users/password(.:format)              devise/passwords#update
#                          PUT    /users/password(.:format)              devise/passwords#update
# cancel_user_registration GET    /users/cancel(.:format)                registrations#cancel
#        user_registration POST   /users(.:format)                       registrations#create
#    new_user_registration GET    /users/sign_up(.:format)               registrations#new
#   edit_user_registration GET    /users/edit(.:format)                  registrations#edit
#                          PATCH  /users(.:format)                       registrations#update
#                          PUT    /users(.:format)                       registrations#update
#                          DELETE /users(.:format)                       registrations#destroy
#        user_confirmation POST   /users/confirmation(.:format)          devise/confirmations#create
#    new_user_confirmation GET    /users/confirmation/new(.:format)      devise/confirmations#new
#                          GET    /users/confirmation(.:format)          devise/confirmations#show
#        admin_sidekiq_web        /admin/sidekiq                         Sidekiq::Web
#      publish_admin_story POST   /admin/stories/:id/publish(.:format)   admin/stories#publish
#    unpublish_admin_story POST   /admin/stories/:id/unpublish(.:format) admin/stories#unpublish
#            admin_stories GET    /admin/stories(.:format)               admin/stories#index
#         edit_admin_story GET    /admin/stories/:id/edit(.:format)      admin/stories#edit
#              admin_story GET    /admin/stories/:id(.:format)           admin/stories#show
#                          PATCH  /admin/stories/:id(.:format)           admin/stories#update
#                          PUT    /admin/stories/:id(.:format)           admin/stories#update
#                    admin GET    /admin(.:format)                       admin/admin#index
#            admin_api_key GET    /admin/api_key(.:format)               admin/admin#api_key
#     admin_api_key_create PATCH  /admin/api_key/create(.:format)        admin/admin#create_api_key
# admin_api_key_regenerate GET    /admin/api_key/regenerate(.:format)    admin/admin#regenerate_api_key
# admin_api_key_deactivate GET    /admin/api_key/deactivate(.:format)    admin/admin#deactivate_api_key
#   admin_api_key_activate GET    /admin/api_key/activate(.:format)      admin/admin#activate_api_key
#    admin_api_key_destroy GET    /admin/api_key/destroy(.:format)       admin/admin#destroy_api_key
#              api_stories GET    /api/stories(.:format)                 api/stories#index {:format=>"json"}
#                api_story GET    /api/stories/:id(.:format)             api/stories#show {:format=>"json"}
#    api_published_stories GET    /api/published_stories(.:format)       api/stories#published_stories {:format=>"json"}
#                      api GET    /api/stories/:id/idml(.:format)        api/stories#idml {:format=>"json"}
#                     root GET    /                                      static_pages#homepage
#            publish_story POST   /stories/:id/publish(.:format)         stories#publish
#          unpublish_story POST   /stories/:id/unpublish(.:format)       stories#unpublish
#                  stories POST   /stories(.:format)                     stories#create
#                new_story GET    /stories/new(.:format)                 stories#new
#               edit_story GET    /stories/:id/edit(.:format)            stories#edit
#                    story GET    /stories/:id(.:format)                 stories#show
#                          PATCH  /stories/:id(.:format)                 stories#update
#                          PUT    /stories/:id(.:format)                 stories#update
#                          DELETE /stories/:id(.:format)                 stories#destroy
#       training_worksheet GET    /training_worksheet(.:format)          stories#training_worksheet
#                  example GET    /example(.:format)                     stories#example
#                          GET    /robots.txt(.:format)                  RobotsTxt
#

Rails.application.routes.draw do
  # devise
  devise_for :users, controllers: { registrations: "registrations" }

  # TODO: Have all devise paths namespaced from root
  # devise_scope :user do
  #   match '/sign-in' => "devise/sessions#new", :as => :login, via: :get
  # end

  # admin routes
  authenticate :user, lambda { |u| u.admin? } do
    namespace :admin do
      # Sidekiq monitoring
      require 'sidekiq/web'
      mount Sidekiq::Web => '/sidekiq'

      # admin access to user stories
      resources :stories, except: [:new, :create, :destroy] do
        member do
          post 'publish'
          post 'unpublish'
        end
      end

      # admin root page
      match '/', to: 'admin#index', via: :get

      # admin api key routes
      match '/api_key', to: 'admin#api_key', via: :get
      match '/api_key/create', to: 'admin#create_api_key', via: :patch
      match '/api_key/regenerate', to: 'admin#regenerate_api_key', via: :get
      match '/api_key/deactivate', to: 'admin#deactivate_api_key', via: :get
      match '/api_key/activate', to: 'admin#activate_api_key', via: :get
      match '/api_key/destroy', to: 'admin#destroy_api_key', via: :get
    end
  end

  # api pages
  namespace :api, defaults: {format: 'json'} do
    resources :stories, only: [:index, :show]

    # list all published stories
    get 'published_stories', to: 'stories#published_stories'

    # get idml file
    get 'stories/:id/idml', to: 'stories#idml'
  end

  # static pages
  root 'static_pages#homepage'

  # stories
  resources :stories, except: [:index] do
    member do
      post 'publish'
      post 'unpublish'
    end
  end

  # training worksheet
  match '/training_worksheet', to: 'stories#training_worksheet', via: :get

  # my story example
  match '/example', to: 'stories#example', via: :get

  # robots.txt
  get '/robots.txt' => RobotsTxt
end
