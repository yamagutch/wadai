Rails.application.routes.draw do
  
  root 'hot#index'
  
  resources :hot do
    collection do
      get :index
      get :region
      get :trigger
    end
  end
  
end
