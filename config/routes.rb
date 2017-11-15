Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  post "files" => "files/create"
  get "files/:md5" => "files/show"
end
