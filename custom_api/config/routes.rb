# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html
Rails.application.routes.draw do
    get 'custom_api/allowed_statuses/:id', to: 'custom_api#allowed_statuses', defaults: { format: 'json' }
  end
  