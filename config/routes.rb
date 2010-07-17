Shapado::Application.routes.draw do
  match '/oauth/start' => 'oauth#start', :as => :oauth_authorize
  match '/oauth/callback' => 'oauth#callback', :as => :oauth_callback
  match '/twitter/start' => 'twitter#start', :as => :twitter_authorize
  match '/twitter/callback' => 'twitter#callback', :as => :twitter_callback
  match '/twitter/share' => 'twitter#share', :as => :twitter_share
  match 'users' => '#index', :as => :devise_for, :path_names => { :sign_in => 'login', :sign_out => 'logout' }
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
      any :unfollow
      any :change_preferred_tags
      any :follow
    end
  end

  resource :session
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
      any :hide
    end
  end

  resources :imports do
    collection do
      post :send_confirmation
    end
  end

  match '/questions/:id/:slug' => 'questions#show', :as => :se_url, :via => get, :id => /\d+/

  resources :questions do
    resources :comments

    resources :answers do
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

  resources :widgets do
    member do
      post :move
    end
  end

  resources :members
  match 'controlleradmin/managepath_prefix/managename_prefixmanage_' => '#index', :as => :with_options
  match '/search.:format' => 'searches#index', :as => :search
  match '/about' => 'groups#show', :as => :about
  match '/' => 'welcome#index'
  match '/:controller(/:action(/:id))'
end
