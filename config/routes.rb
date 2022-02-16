Rails.application.routes.draw do
  devise_for :admins
  resources :user_blogs
  resources :blogs
  devise_for :users

  namespace :api do
    namespace :v1 do
      namespace :user do
        post "sign_up", to: "sessions#sign_up"
        post "sign_in", to: "sessions#sign_in"
        delete "sign_out", to: "sessions#sign_out"
        get "me", to: "sessions#me"
        put "update", to: "sessions#update"
      end
    end
  end

  namespace :api do
    namespace :v1 do
      namespace :blog do
        get "blogs", to: "blogs#index"
        get "blogs/:id", to: "blogs#show"
        post "blogs", to: "blogs#create"
        put "update/:id", to: "blogs#update"
        delete "destroy/:id", to: "blogs#destroy"
        get "/", to: "user_blogs#index"
      end
    end
  end

  namespace :api do
    namespace :v1 do
      namespace :admin do
        get "/", to: "admins#index"
        get "me/", to: "admins#me"
        get "show_blog", to: "admins#show_blog"
        get "show_users", to: "admins#show_users"
        get "show_users_waiting", to: "admins#show_users_waiting"
        post "sign_up", to: "admins#sign_up"
        post "sign_in", to: "admins#sign_in"
        post "confirmeduser/:id", to: "admins#confirmeduser"
        put "resetpasswd/:id", to: "admins#resetpasswd"
        delete "sign_out", to: "admins#sign_out"
        delete "deleteuserwarining/:id", to: "admins#deleteuserwarining"
        delete "deliteuserwhichblog/:id", to: "admins#deliteuserwhichblog"
        delete "deleteblog/:id", to: "admins#deleteblog"
      end
    end
  end

end
