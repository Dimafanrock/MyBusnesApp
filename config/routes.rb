Rails.application.routes.draw do
   devise_for :users 

   root "home#homepage"
   get "homepage", to: "home#homepage"
   get "dashboard", to: "home#dashboard"
   resources :purchases do
      collection do
        get 'remove_all'
        get 'last_month'
        get 'last_year'
      end   
   end  

   
end
