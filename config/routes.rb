Rails.application.routes.draw do

  root 'welcome#index'
  mount Facebook::Messenger::Server, at: 'bot'

end
