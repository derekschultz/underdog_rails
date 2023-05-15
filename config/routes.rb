Rails.application.routes.draw do
  get '/players/search', to: 'players#search'
  get '/players/:id', to: 'players#show'
end
