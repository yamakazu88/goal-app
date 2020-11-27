Rails.application.routes.draw do
  root 'goals#index'
  post '/callback' => 'goals#callback'
end
