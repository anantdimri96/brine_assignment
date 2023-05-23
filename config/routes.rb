# frozen_string_literal: true

require 'sidekiq/web'
require 'sidekiq/cron/web'
Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'

  namespace :api do
    namespace :v1 do
      resources :alerts, only: %i[create destroy index]
    end
  end
end
