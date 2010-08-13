Shapado::Application.routes.draw do
  match '/oauth/start' => 'oauth#start', :as => :oauth_authorize
  match '/oauth/callback' => 'oauth#callback', :as => :oauth_callback
  match '/twitter/start' => 'twitter#start', :as => :twitter_authorize
  match '/twitter/callback' => 'twitter#callback', :as => :twitter_callback
  match '/twitter/share' => 'twitter#share', :as => :twitter_share
  devise_for(:users,
             :path_names => {:sign_in => 'login', :sign_out => 'logout'},
             :controllers => {:registrations => 'users'})
  match 'confirm_age_welcome' => 'welcome#confirm_age', :as => :confirm_age_welcome
  match '/change_language_filter' => 'welcome#change_language_filter', :as => :change_language_filter
  match '/register' => 'users#create', :as => :register
  match '/signup' => 'users#new', :as => :signup
  match '/moderate' => 'admin/moderate#index', :as => :moderate
  match '/moderate/ban' => 'admin/moderate#ban', :as => :ban
  match '/moderate/unban' => 'admin/moderate#unban', :as => :unban
  match '/facts' => 'welcome#facts', :as => :facts
  match '/plans' => 'doc#plans', :as => :plans
  match '/chat' => 'doc#chat', :as => :chat
  match '/feedback' => 'welcome#feedback', :as => :feedback
  match '/send_feedback' => 'welcome#send_feedback', :as => :send_feedback
  match '/settings' => 'users#edit', :as => :settings
  match '/tos' => 'doc#tos', :as => :tos
  match '/privacy' => 'doc#privacy', :as => :privacy

  resources :users do
    collection do
      get :autocomplete_for_user_login
    end

    member do
      post :unfollow
      post :change_preferred_tags
      post :follow
    end
  end

  resources :ads
  resources :adsenses
  resources :adbards
  resources :badges

  resources :pages do
    member do
      get :js
      get :css
    end
  end

  resources :announcements do
    collection do
      post :hide
    end
  end

  resources :imports do
    collection do
      post :send_confirmation
    end
  end

  get '/questions/:id/:slug' => 'questions#show', :as => :se_url, :id => /\d+/

  resources :questions do
    collection do
      get :tags
      get :tags_for_autocomplete
      get :unanswered
      get :related_questions
    end

    member do
      get :solve
      get :unsolve
      get :flag
      get :favorite
      get :unfavorite
      get :watch
      get :unwatch
      get :history
      get :revert
      get :diff
      get :move
      put :move_to
      get :retag
      put :retag_to
      post :close
    end

    resources :comments

    resources :answers do
      member do
        get :flag
        get :history
        get :diff
        get :revert
      end

      resources :comments
    end

    resources :close_requests
  end

  match 'questions/tags/:tags' => 'questions#index', :constraints => { :tags => /\S+/ }
  match 'questions/unanswered/tags/:tags' => 'questions#unanswered'

  resources :groups do
    collection do
      get :autocomplete_for_group_slug
    end

    member do
      get :logo
      get :allow_custom_ads
      get :disallow_custom_ads
      get :favicon
      get :close
      get :accept
      get :css
    end
  end

  resources :votes
  resources :flags

  scope '/manage' do
    resources :widgets do
      member do
        post :move
      end
    end

    resources :members
  end

  scope '/manage', :name_prefix => 'manage' do
    controller 'admin/manage' do
      match 'properties' => :properties
      match 'theme' => :theme
      match 'actions' => :actions
      match 'stats' => :stats
      match 'reputation' => :reputation
      match 'domain' => :domain
    end
  end

  match '/search' => 'searches#index', :as => :search
  match '/about' => 'groups#show', :as => :about
  root :to => 'welcome#index'
  match '/:controller(/:action(/:id))'
end
