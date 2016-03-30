Rails.application.routes.draw do

  resources :cats
  resources :cat_rental_requests #do
  #   member do
  #     post 'approve'
  #   end
  #
  #   member do
  #     post 'deny'
  #   end
  # end
end
