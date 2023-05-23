# frozen_string_literal: true

require 'sidekiq'
require 'sidekiq-cron'
require 'sidekiq/web'

Sidekiq.configure_server do |config|
  config.redis = { url: 'redis://redis:6379/1' }
end

Sidekiq.configure_client do |config|
  config.redis = { url: 'redis://redis:6379/1' }
end

schedule_file = 'config/schedule.yml'

if File.exist?(schedule_file)
  sidekiq_cron = YAML.load_file(schedule_file)
  Sidekiq::Cron::Job.load_from_hash sidekiq_cron
end
